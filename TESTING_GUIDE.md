# Testing Guide for Enhanced Web Interface

## 🧪 Complete Testing Checklist

This guide will help you verify that all the new features are working correctly.

---

## 📋 Pre-Testing Requirements

### System Requirements
- Ubuntu/Debian Linux (or similar)
- Python 3.8+ installed
- Internet connection for tool downloads
- Sudo access (for tool installation)
- 2GB+ free disk space
- Modern web browser (Chrome, Firefox, Safari, Edge)

### Test Domain
For testing, use a domain you own or have permission to test:
- **Safe test domains:** `example.com`, `testphp.vulnweb.com`, `scanme.nmap.org`
- **Your own domain:** Best for realistic testing

---

## ✅ Test 1: Auto Tool Installation

### Objective
Verify that start_web.sh automatically installs missing tools.

### Steps
```bash
# 1. Make script executable (if not already)
chmod +x start_web.sh

# 2. Run with sudo
sudo ./start_web.sh

# Expected Output:
# ==========================================
#    CTXREC Web Interface Launcher
# ==========================================
# 
# Checking & Installing Required Tools
# ⚠️  Missing tools detected: httpx subfinder nuclei ...
# Starting automatic installation...
# [*] Running install_basic_tools.sh...
# 
# Tool Installation Summary
# ✓ dig
# ✓ curl
# ✓ nmap
# ✓ httpx
# ... (continues)
# 
# Installed: 11/11 tools
```

### Success Criteria
- ✅ Script detects missing tools
- ✅ Auto-runs installer (10-15 min wait is normal)
- ✅ Shows installation summary with ✓ marks
- ✅ Web server starts on http://localhost:5000

### Troubleshooting
❌ **If tools don't install:**
```bash
# Manual installation
sudo ./install_basic_tools.sh
# OR
./garudrecon install -f ALL
```

---

## ✅ Test 2: Tool Status Warning Banner

### Objective
Verify that missing tools trigger a warning banner.

### Steps
```bash
# 1. If tools are already installed, temporarily rename one:
sudo mv /usr/bin/httpx /usr/bin/httpx.bak

# 2. Start server
python3 web_backend.py

# 3. Open browser: http://localhost:5000
```

### Expected Result
At the top of the page, you should see:
```
⚠️ Warning: Some reconnaissance tools are not installed. 
Results may be limited. Run sudo ./start_web.sh to auto-install tools.
```

### Success Criteria
- ✅ Warning banner appears at page load
- ✅ Banner has orange/yellow styling
- ✅ Message is clear and actionable

### Cleanup
```bash
# Restore httpx
sudo mv /usr/bin/httpx.bak /usr/bin/httpx
```

---

## ✅ Test 3: Scan Type Tool Descriptions

### Objective
Verify that scan type cards show which tools will be used.

### Steps
1. Open http://localhost:5000
2. Look at the three scan type cards (Light, Cool, Ultra)
3. Check for tool descriptions at the bottom of each card

### Expected Result

**Light Card:**
```
⚡ Light
Fast scan with basic recon and vulnerability checks
~5-10 minutes
Tools: dig, nmap, httpx, waybackurls, dalfox, sqlmap, curl
```

**Cool Card:**
```
🔥 Cool
Medium scan with subdomain enumeration and extensive checks
~20-30 minutes
Tools: subfinder, assetfinder, amass, httpx, dnsx, naabu, nuclei, waybackurls, katana
```

**Ultra Card:**
```
🚀 Ultra
Comprehensive deep scan with all tools and techniques
~1-2 hours
Tools: All Cool tools + github-subdomains, shosubgo, crt.sh, arjun, ffuf, and 20+ more
```

### Success Criteria
- ✅ All three cards show tool lists
- ✅ Tools are in small gray text below time estimate
- ✅ Text is readable and clear

---

## ✅ Test 4: Start a Light Scan

### Objective
Run a complete scan and verify all features work.

### Steps
```bash
# 1. Ensure server is running
python3 web_backend.py

# 2. Open http://localhost:5000
# 3. Enter domain: example.com
# 4. Select: Light scan
# 5. Click "Start Scan"
# 6. Watch the process
```

### Expected Result - Progress Card

**Header:**
```
Scan Progress
Scan ID: 54df7543-bd71-406e-ab12-d138246f3558
Domain: example.com
Type: LIGHT
Status: RUNNING
```

**Progress Bar:**
- Starts at 10%
- Moves to 50% when running
- Reaches 100% when complete

**Logs (Color-coded):**
```
▶ [2025-11-22 08:27:46] Starting LIGHT scan for example.com (BLUE)
▶ [2025-11-22 08:27:46] Output directory: scans/... (BLUE)
▶ [2025-11-22 08:27:46] [1/7] DNS Resolution... (BLUE)
✓ [2025-11-22 08:27:47] Found 1 A records (GREEN)
▶ [2025-11-22 08:27:47] [2/7] Port Scanning (common ports)... (BLUE)
  Using tool: nmap (PURPLE HIGHLIGHT)
✓ [2025-11-22 08:27:51] Found 2 open ports (GREEN)
▶ [2025-11-22 08:27:51] [3/7] HTTP Probing... (BLUE)
  Using tool: httpx (PURPLE HIGHLIGHT)
✓ [2025-11-22 08:27:51] HTTP probe complete (GREEN)
⚠️ [2025-11-22 08:27:51] Skipping XSS check (dalfox not found) (YELLOW)
```

### Success Criteria
- ✅ Progress card appears immediately
- ✅ Logs stream in real-time (update every 2 seconds)
- ✅ Logs are color-coded correctly
- ✅ Tool names are highlighted in purple
- ✅ Progress bar animates smoothly
- ✅ Status badge updates (QUEUED → RUNNING → COMPLETED)

---

## ✅ Test 5: Results Display (Visual Cards)

### Objective
Verify that results show as beautiful cards, not raw JSON.

### Expected Result

**After scan completes, you should see:**

```
╔════════════════════════════════════════════════════════╗
║                   Scan Results                         ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  ╔═══════╗  ╔═══════╗  ╔═══════╗  ╔═══════╗         ║
║  ║ 🌐    ║  ║ 🔌    ║  ║ 🔗    ║  ║ ⚠️    ║         ║
║  ║   1   ║  ║   2   ║  ║  150  ║  ║   3   ║         ║
║  ║ DNS   ║  ║ Ports ║  ║ URLs  ║  ║  XSS  ║         ║
║  ╚═══════╝  ╚═══════╝  ╚═══════╝  ╚═══════╝         ║
║                                                        ║
║  ╔═══════╗                                            ║
║  ║ 💉    ║                                            ║
║  ║   0   ║                                            ║
║  ║ SQLi  ║                                            ║
║  ╚═══════╝                                            ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
```

**NOT this (old way):**
```json
{
  "findings": {
    "dns_records": 1,
    "open_ports": 2,
    "urls_found": 150,
    "xss_findings": 3,
    "sqli_findings": 0
  }
}
```

### Success Criteria
- ✅ No raw JSON visible
- ✅ Summary cards displayed in grid
- ✅ Large numbers with icons
- ✅ Cards have hover effects (lift and glow)
- ✅ Responsive layout (stacks on mobile)

---

## ✅ Test 6: File List Display

### Objective
Verify that generated files appear as clickable cards.

### Expected Result

Below the summary cards, you should see:

```
📁 Generated Files

┌──────────────────────────────┐  ┌──────────────────────────────┐
│ 📄 dns_a_records.txt         │  │ 📄 ports.txt                 │
│ 1 lines                      │  │ 12 lines                     │
└──────────────────────────────┘  └──────────────────────────────┘

┌──────────────────────────────┐  ┌──────────────────────────────┐
│ 📄 urls.txt                  │  │ 📄 xss_findings.txt          │
│ 150 lines                    │  │ 3 lines                      │
└──────────────────────────────┘  └──────────────────────────────┘
```

**File card features:**
- Clickable (cursor becomes pointer on hover)
- Shows filename with 📄 icon
- Shows line count
- Hover effect (lifts and glows blue)

### Success Criteria
- ✅ All .txt files listed
- ✅ Line counts displayed
- ✅ Cards are clickable
- ✅ Hover effects work
- ✅ Grid layout (2-4 columns depending on screen size)

---

## ✅ Test 7: File Viewer Modal

### Objective
Verify that clicking a file opens a modal with contents.

### Steps
1. After scan completes, click on `urls.txt` card
2. Modal should appear

### Expected Result

```
╔══════════════════════════════════════════════════════╗
║  📄 urls.txt                              ✕ Close  ║
╠══════════════════════════════════════════════════════╣
║                                                      ║
║  https://example.com/                                ║
║  https://example.com/about                           ║
║  https://example.com/contact                         ║
║  https://example.com/products                        ║
║  https://example.com/services                        ║
║  https://example.com/blog                            ║
║  https://example.com/careers                         ║
║  ... (more URLs)                                     ║
║                                                      ║
╠══════════════════════════════════════════════════════╣
║  [Download File]  [Close]                            ║
╚══════════════════════════════════════════════════════╝
```

**Features:**
- Dark theme modal
- Monospace font (Courier New)
- Scrollable if content is long
- Close button (X) in top-right
- Download button at bottom
- Click outside modal to close

### Success Criteria
- ✅ Modal opens on file click
- ✅ File contents displayed correctly
- ✅ Scrollbar appears if needed
- ✅ Close button works
- ✅ Click outside closes modal
- ✅ Download button works

---

## ✅ Test 8: Download Individual File

### Objective
Verify file download functionality.

### Steps
1. Click on any file card to open modal
2. Click "Download File" button
3. Browser should download the file

### Expected Result
- File downloads to your Downloads folder
- Filename matches original (e.g., `urls.txt`)
- Content is correct (plain text format)

### Success Criteria
- ✅ Download initiates
- ✅ Filename is correct
- ✅ Content is readable
- ✅ No errors in browser console

---

## ✅ Test 9: Download Full Results (JSON)

### Objective
Verify JSON download functionality.

### Steps
1. After scan completes, click "📥 Download Full Results (JSON)"
2. Browser should download JSON file

### Expected Result
- Filename: `ctxrec-example.com-{scan_id}.json`
- Content: Complete scan data including logs, results, timestamps

### Example JSON:
```json
{
  "scan_id": "54df7543-bd71-406e-ab12-d138246f3558",
  "domain": "example.com",
  "scan_type": "light",
  "status": "completed",
  "created_at": "2025-11-22T08:27:46.568613",
  "start_time": "2025-11-22T08:27:46.568730",
  "end_time": "2025-11-22T08:27:51.552489",
  "results": { ... },
  "log": [ ... ]
}
```

### Success Criteria
- ✅ JSON downloads successfully
- ✅ Filename is descriptive
- ✅ JSON is valid (can be opened in editor)
- ✅ All data is present

---

## ✅ Test 10: Recent Scans List

### Objective
Verify scan history displays correctly.

### Steps
1. After completing a scan, scroll to "Recent Scans" section
2. Your scan should be listed

### Expected Result

```
Recent Scans

┌──────────────┬──────┬───────────┬─────────────────────┬────────┐
│ Domain       │ Type │ Status    │ Started             │ Action │
├──────────────┼──────┼───────────┼─────────────────────┼────────┤
│ example.com  │ LIGHT│ COMPLETED │ 11/22/2025, 8:27 AM │ View   │
└──────────────┴──────┴───────────┴─────────────────────┴────────┘
```

**Features:**
- Table format
- Status badges (colored)
- View link (clickable)
- Sorted by date (newest first)

### Steps to Test View Link
1. Click "View" link
2. Should scroll to scan progress card
3. Should display that scan's logs and results

### Success Criteria
- ✅ Scans listed in table
- ✅ Status badges colored correctly
- ✅ View link works
- ✅ Clicking view loads correct scan
- ✅ Can view old scan results

---

## ✅ Test 11: Responsive Design (Mobile)

### Objective
Verify interface works on mobile devices.

### Steps
1. Open http://localhost:5000 on mobile device
   OR
2. In Chrome: F12 → Toggle device toolbar → Select iPhone/Android

### Expected Result
- Single column layout (cards stack vertically)
- Scan type cards: one per row
- Summary cards: one per row
- File cards: one per row
- Modal fits screen (with padding)
- All text is readable
- Buttons are tappable (not too small)

### Success Criteria
- ✅ Layout adapts to small screens
- ✅ No horizontal scrolling
- ✅ Text is legible
- ✅ Buttons are accessible
- ✅ Modal works on mobile

---

## ✅ Test 12: Error Handling

### Objective
Verify errors display correctly in logs.

### Steps
```bash
# 1. Temporarily break a tool (e.g., rename httpx)
sudo mv /usr/bin/httpx /usr/bin/httpx.bak

# 2. Start a scan
# 3. Watch logs
```

### Expected Result

Logs should show:
```
▶ [3/7] HTTP Probing... (BLUE)
❌ ERROR: httpx not found (RED, BOLD)
⚠️ WARNING: Skipping HTTP probe (YELLOW)
```

### Success Criteria
- ✅ Errors show in red with ❌
- ✅ Warnings show in yellow with ⚠️
- ✅ Scan continues despite error
- ✅ Final status may be "completed" or "failed"

### Cleanup
```bash
sudo mv /usr/bin/httpx.bak /usr/bin/httpx
```

---

## ✅ Test 13: Tool Name Highlighting

### Objective
Verify tool names are highlighted in logs.

### Steps
1. Start any scan
2. Watch logs as they stream

### Expected Result

Tool names should be **highlighted in purple**:
```
Running httpx...        ← "httpx" is purple
Using subfinder...      ← "subfinder" is purple
Starting nuclei scan... ← "nuclei" is purple
```

**Highlighted tools:**
- httpx, subfinder, nuclei, nmap, dig
- waybackurls, dalfox, sqlmap, dnsx, naabu
- katana, gau, and more

### Success Criteria
- ✅ Tool names highlighted when mentioned
- ✅ Purple background with darker purple text
- ✅ Easy to spot in logs
- ✅ Case-insensitive matching

---

## ✅ Test 14: Progress Bar Animation

### Objective
Verify smooth progress bar transitions.

### Steps
1. Start a scan
2. Watch progress bar

### Expected Result
- **Queued:** 10% width
- **Running:** 50% width (smooth transition)
- **Completed:** 100% width (smooth transition)
- **Gradient background:** Blue to purple
- **Animated:** Gentle pulsing effect

### Success Criteria
- ✅ Bar width transitions smoothly
- ✅ No jumps or glitches
- ✅ Gradient looks good
- ✅ Percentage makes sense

---

## ✅ Test 15: Multiple Scans

### Objective
Verify system handles multiple scans correctly.

### Steps
1. Start scan #1 (Light on example.com)
2. Immediately start scan #2 (Light on google.com)
3. Both should run simultaneously

### Expected Result
- Two scan IDs generated
- Both appear in Recent Scans
- Logs don't mix together
- Results are separate

### Success Criteria
- ✅ Multiple scans run concurrently
- ✅ No log/result cross-contamination
- ✅ Each scan has unique ID
- ✅ Can view results for both

---

## 🐛 Common Issues & Solutions

### Issue 1: Tools Not Installing
**Symptom:** Script says "tools missing" but doesn't install

**Solution:**
```bash
# Run manually with verbose output
sudo bash -x ./install_basic_tools.sh
```

### Issue 2: Port 5000 Already in Use
**Symptom:** "Address already in use"

**Solution:**
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9
```

### Issue 3: Results Show 0 for Everything
**Symptom:** All metrics are 0

**Solution:**
```bash
# Check tools are installed
./check_tools.sh

# If missing, run:
sudo ./start_web.sh
```

### Issue 4: Modal Doesn't Open
**Symptom:** Click file, nothing happens

**Solution:**
1. Check browser console (F12) for errors
2. Verify scan completed successfully
3. Try refreshing page

### Issue 5: Logs Not Color-Coded
**Symptom:** All logs are same color

**Solution:**
1. Check browser supports CSS variables
2. Try different browser (Chrome/Firefox)
3. Clear browser cache

---

## 📊 Test Results Template

Use this checklist to track your testing:

```
CTXREC Enhanced UI - Test Results
Date: _____________
Tester: _____________

✅ = Pass  ❌ = Fail  ⚠️ = Partial

[ ] Test 1: Auto Tool Installation
[ ] Test 2: Tool Status Warning Banner
[ ] Test 3: Scan Type Tool Descriptions
[ ] Test 4: Start a Light Scan
[ ] Test 5: Results Display (Visual Cards)
[ ] Test 6: File List Display
[ ] Test 7: File Viewer Modal
[ ] Test 8: Download Individual File
[ ] Test 9: Download Full Results (JSON)
[ ] Test 10: Recent Scans List
[ ] Test 11: Responsive Design (Mobile)
[ ] Test 12: Error Handling
[ ] Test 13: Tool Name Highlighting
[ ] Test 14: Progress Bar Animation
[ ] Test 15: Multiple Scans

Overall Result: _____/15 tests passed

Notes:
_____________________________________
_____________________________________
_____________________________________
```

---

## 🎉 Success!

If all tests pass, you've successfully verified the enhanced UI!

**Next Steps:**
1. Share with team for feedback
2. Test on production-like environment
3. Deploy to staging/production
4. Monitor for issues
5. Iterate based on user feedback

---

**Happy Testing!** 🧪✨

For support: https://github.com/arjanchaudharyy/GarudRecon
