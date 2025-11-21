# Bug Fix Summary: Handle Missing DNS/URLs and JSON Parse Errors

## Problem Description

The scan scripts (`scan_light`, `scan_cool`, `scan_ultra`) were failing with the following issues:

1. **File Operation Errors**: When DNS resolution or URL discovery tools were not available or returned no results, the scripts tried to read non-existent files, causing errors like:
   ```
   ./cmd/scan_light: line 154: scans/.../dns_a_records.txt: No such file or directory
   ./cmd/scan_light: line 154: scans/.../urls.txt: No such file or directory
   ```

2. **Invalid JSON Generation**: The missing file reads resulted in empty values in the JSON output, creating invalid JSON like:
   ```json
   "dns_records": ,
   ```
   This caused JSON parse errors in the web interface:
   ```
   ERROR: Expecting value: line 7 column 19 (char 159)
   ```

3. **Domain Input Sanitization**: The web interface didn't strip protocols and trailing slashes from user input, so domains like `https://cto.new/` were passed directly to scan scripts.

## Changes Made

### 1. Fixed `cmd/scan_light` (Lines 144-203)

**Changes:**
- Added `touch` commands to ensure `dns_a_records.txt` and `urls.txt` files exist before counting
- Pre-computed all count variables with safe defaults before generating JSON
- Used parameter expansion `${VAR:-0}` to ensure variables have default values
- Moved all command substitutions outside of heredoc blocks to prevent empty values

**Before:**
```bash
cat >> "$RESULTS_FILE" << EOF
    "dns_records": $(wc -l < "$OUTPUT_DIR/dns_a_records.txt" 2>/dev/null || echo "0"),
    "urls_found": $(wc -l < "$OUTPUT_DIR/urls.txt" 2>/dev/null || echo "0"),
```

**After:**
```bash
# Ensure required files exist
touch "$OUTPUT_DIR/dns_a_records.txt" 2>/dev/null
touch "$OUTPUT_DIR/urls.txt" 2>/dev/null

# Pre-compute counts with defaults
DNS_COUNT=0
URLS_COUNT=0
[[ -f "$OUTPUT_DIR/dns_a_records.txt" ]] && DNS_COUNT=$(wc -l < "$OUTPUT_DIR/dns_a_records.txt" 2>/dev/null || echo "0")

cat >> "$RESULTS_FILE" << EOF
    "dns_records": $DNS_COUNT,
    "urls_found": $URLS_COUNT,
```

### 2. Fixed `cmd/scan_cool` (Lines 198-252)

**Changes:**
- Added safe defaults for all count variables using parameter expansion
- Pre-computed all finding counts before generating JSON
- Ensured proper error handling for missing files

**Key additions:**
```bash
SUBDOMAIN_COUNT=${SUBDOMAIN_COUNT:-0}
RESOLVED_COUNT=${RESOLVED_COUNT:-0}
LIVE_HOSTS=${LIVE_HOSTS:-0}
URL_COUNT=${URL_COUNT:-0}
```

### 3. Fixed `cmd/scan_ultra` (Lines 120-310)

**Changes:**
- Added `touch` commands to ensure intermediate files exist:
  - `reconnaissance/resolved.txt` (line 122)
  - `reconnaissance/js_files.txt` (line 186)
- Added safe defaults for all count variables
- Improved error handling for missing tool outputs

### 4. Enhanced `web_backend.py` (Lines 67-92)

**Changes:**
- Added try-except block to catch `json.JSONDecodeError` when loading scan results
- Improved error reporting by logging JSON parse errors
- Gracefully handles malformed JSON by marking scan as failed with descriptive error

**Before:**
```python
with open(result_file) as f:
    scan_results[scan_id] = json.load(f)
```

**After:**
```python
try:
    with open(result_file) as f:
        scan_results[scan_id] = json.load(f)
except json.JSONDecodeError as e:
    active_scans[scan_id]['status'] = 'failed'
    active_scans[scan_id]['error'] = f"JSON parse error: {str(e)}"
    active_scans[scan_id]['log'].append(f"ERROR: {str(e)}")
```

### 5. Improved `web/script.js` (Lines 16-29)

**Changes:**
- Added domain sanitization to strip protocols and trailing slashes
- Prevents invalid domains from being passed to scan scripts

**Added:**
```javascript
// Strip protocol and trailing slashes from domain
domain = domain.replace(/^(https?:\/\/)?(www\.)?/, '').replace(/\/+$/, '');
```

## Testing

Created comprehensive test script (`test_fixes.sh`) that verifies:
1. ✓ Valid JSON generation with protocols in domain names
2. ✓ Valid JSON generation with invalid/non-existent domains
3. ✓ Required files are always created (even if empty)
4. ✓ No file operation errors in scan output
5. ✓ All three scan types (light, cool, ultra) work correctly

## Result

All scans now:
- Generate valid JSON output regardless of tool availability
- Handle missing files gracefully without errors
- Properly sanitize user input
- Provide better error messages when issues occur
- Complete successfully even when no results are found
