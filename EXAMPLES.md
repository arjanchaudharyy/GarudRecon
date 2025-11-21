# GarudRecon Usage Examples

Practical examples for using GarudRecon effectively.

## Web Interface Examples

### Example 1: Basic Light Scan
**Scenario**: Quick security check of a single domain

1. Start the web interface:
```bash
./garudrecon web
```

2. Open browser: http://localhost:5000

3. Enter domain: `example.com`

4. Select: **Light** scan

5. Click "Start Scan"

**Expected Results** (5-10 minutes):
- DNS records discovered
- Open ports identified
- HTTP endpoints probed
- Basic XSS/SQLi checks
- Security headers analyzed

---

### Example 2: Medium Subdomain Enumeration
**Scenario**: Bug bounty reconnaissance on a target

1. Open web interface

2. Enter domain: `target.com`

3. Select: **Cool** scan

4. Monitor progress in real-time

**Expected Results** (20-30 minutes):
- 50-500+ subdomains discovered
- Live hosts identified
- 500-5000+ URLs collected
- JavaScript files found
- Vulnerability findings
- Subdomain takeover checks

---

### Example 3: Comprehensive Security Audit
**Scenario**: Full penetration testing preparation

1. Open web interface

2. Enter domain: `client.com`

3. Select: **Ultra** scan

4. Let it run completely (1-2 hours)

**Expected Results**:
- 500-1000+ subdomains
- Full port scanning
- 10,000+ URLs
- Directory enumeration
- Deep vulnerability scanning
- Screenshots captured
- Nuclei findings

---

## API Examples

### Example 4: Automated Scanning with API

**Start a Light Scan:**
```bash
SCAN_ID=$(curl -s -X POST http://localhost:5000/api/scan \
  -H "Content-Type: application/json" \
  -d '{"domain": "example.com", "scan_type": "light"}' \
  | jq -r '.scan_id')

echo "Scan started: $SCAN_ID"
```

**Poll for Status:**
```bash
while true; do
  STATUS=$(curl -s http://localhost:5000/api/scan/$SCAN_ID | jq -r '.status')
  echo "Status: $STATUS"
  
  if [ "$STATUS" = "completed" ] || [ "$STATUS" = "failed" ]; then
    break
  fi
  
  sleep 5
done
```

**Get Results:**
```bash
curl -s http://localhost:5000/api/scan/$SCAN_ID | jq '.' > results.json
echo "Results saved to results.json"
```

---

### Example 5: Batch Scanning Multiple Domains

**Bash Script:**
```bash
#!/bin/bash

DOMAINS=(
  "example1.com"
  "example2.com"
  "example3.com"
)

for DOMAIN in "${DOMAINS[@]}"; do
  echo "Starting scan for $DOMAIN..."
  
  curl -X POST http://localhost:5000/api/scan \
    -H "Content-Type: application/json" \
    -d "{\"domain\": \"$DOMAIN\", \"scan_type\": \"light\"}" \
    -s | jq '.'
  
  sleep 2
done

echo "All scans queued!"
```

---

### Example 6: Python API Integration

**Python Script:**
```python
#!/usr/bin/env python3
import requests
import time
import json

API_BASE = "http://localhost:5000"

def start_scan(domain, scan_type="light"):
    """Start a new scan"""
    response = requests.post(
        f"{API_BASE}/api/scan",
        json={"domain": domain, "scan_type": scan_type}
    )
    return response.json()

def get_scan_status(scan_id):
    """Get scan status"""
    response = requests.get(f"{API_BASE}/api/scan/{scan_id}")
    return response.json()

def wait_for_completion(scan_id, timeout=3600):
    """Wait for scan to complete"""
    start_time = time.time()
    
    while True:
        if time.time() - start_time > timeout:
            print(f"Timeout waiting for scan {scan_id}")
            return None
        
        status = get_scan_status(scan_id)
        
        if status['status'] in ['completed', 'failed']:
            return status
        
        print(f"Status: {status['status']}...")
        time.sleep(5)

# Main usage
if __name__ == "__main__":
    # Start scan
    print("Starting scan...")
    scan = start_scan("example.com", "cool")
    scan_id = scan['scan_id']
    print(f"Scan ID: {scan_id}")
    
    # Wait for completion
    print("Waiting for completion...")
    result = wait_for_completion(scan_id)
    
    if result:
        print("Scan completed!")
        print(json.dumps(result['findings'], indent=2))
        
        # Save results
        with open(f"results_{scan_id}.json", "w") as f:
            json.dump(result, f, indent=2)
```

---

## Command Line Examples

### Example 7: Light Scan from CLI

```bash
./cmd/scan_light -d example.com -o output/light-scan
```

**Output Structure:**
```
output/light-scan/
├── results.json
├── summary.txt
├── dns_a_records.txt
├── ports.txt
├── httpx.txt
├── urls.txt
├── xss_findings.txt
├── sqli_findings.txt
└── headers.txt
```

---

### Example 8: Cool Scan with Custom Output

```bash
./cmd/scan_cool -d example.com -o /tmp/my-scan-$(date +%Y%m%d)
```

---

### Example 9: Ultra Scan for Penetration Testing

```bash
# Start in background and log output
nohup ./cmd/scan_ultra -d target.com -o scans/ultra-target > scan.log 2>&1 &

# Monitor progress
tail -f scan.log
```

---

## Real-World Scenarios

### Example 10: Bug Bounty Workflow

**Step 1: Initial Recon (Light)**
```bash
# Quick check to see if target is interesting
./cmd/scan_light -d bugbounty-target.com -o bb-light
```

**Step 2: If interesting, go deeper (Cool)**
```bash
# Find subdomains and more attack surface
./cmd/scan_cool -d bugbounty-target.com -o bb-cool
```

**Step 3: Focus on specific findings (Manual)**
```bash
# Use findings from Cool scan
cat bb-cool/subdomains.txt | httpx -silent > live-hosts.txt
cat bb-cool/urls.txt | grep -i "admin" > interesting-urls.txt
```

---

### Example 11: Red Team Assessment

**Phase 1: Passive Recon**
```bash
# Start with Cool scan for OSINT
./cmd/scan_cool -d target-corp.com -o redteam/passive
```

**Phase 2: Active Recon**
```bash
# Follow up with Ultra for deep analysis
./cmd/scan_ultra -d target-corp.com -o redteam/active
```

**Phase 3: Analysis**
```bash
# Analyze results
cat redteam/active/vulnerabilities/nuclei_findings.txt
cat redteam/active/reconnaissance/resolved.txt
```

---

### Example 12: Continuous Monitoring

**Setup Cron Job:**
```bash
# Edit crontab
crontab -e

# Add daily light scan
0 2 * * * cd /path/to/GarudRecon && ./cmd/scan_light -d mysite.com -o scans/daily-$(date +\%Y\%m\%d)
```

**Or via API:**
```python
# monitoring.py
import schedule
import time
from scan_api import start_scan, wait_for_completion

def daily_scan():
    print("Starting daily scan...")
    scan = start_scan("mysite.com", "light")
    result = wait_for_completion(scan['scan_id'])
    
    # Check for new issues
    if result['findings']['xss_findings'] > 0:
        send_alert("XSS found!")

schedule.every().day.at("02:00").do(daily_scan)

while True:
    schedule.run_pending()
    time.sleep(60)
```

---

### Example 13: Comparison Scanning

**Before Deployment:**
```bash
./cmd/scan_cool -d staging.example.com -o scans/before-deploy
```

**After Deployment:**
```bash
./cmd/scan_cool -d staging.example.com -o scans/after-deploy
```

**Compare Results:**
```bash
# Compare subdomain counts
echo "Before: $(wc -l < scans/before-deploy/subdomains.txt)"
echo "After: $(wc -l < scans/after-deploy/subdomains.txt)"

# Compare findings
diff scans/before-deploy/summary.txt scans/after-deploy/summary.txt
```

---

### Example 14: Multi-Target Campaign

**targets.txt:**
```
target1.com
target2.com
target3.com
subdomain1.target1.com
subdomain2.target2.com
```

**Scan All:**
```bash
#!/bin/bash

while IFS= read -r target; do
  echo "Scanning $target..."
  
  # Determine scan type based on domain
  if [[ $target == *.* ]]; then
    # Subdomain - use light
    ./cmd/scan_light -d "$target" -o "campaign/light-$target"
  else
    # Main domain - use cool
    ./cmd/scan_cool -d "$target" -o "campaign/cool-$target"
  fi
  
  echo "Completed $target"
  sleep 30  # Rate limiting
done < targets.txt
```

---

### Example 15: Custom Scan Pipeline

**Combined Scan Approach:**
```bash
#!/bin/bash

DOMAIN=$1
OUTPUT_BASE="custom-scan-$DOMAIN"

echo "Phase 1: Light scan for quick wins..."
./cmd/scan_light -d "$DOMAIN" -o "$OUTPUT_BASE/phase1"

echo "Phase 2: Extract interesting targets..."
INTERESTING=$(cat "$OUTPUT_BASE/phase1/urls.txt" | grep -E "(admin|api|upload)" | head -20)

echo "Phase 3: Deep dive on interesting targets..."
echo "$INTERESTING" | while read url; do
  # Custom testing on interesting URLs
  echo "Testing: $url"
  # Add your custom tools here
done

echo "Phase 4: Generate report..."
cat > "$OUTPUT_BASE/report.txt" << EOF
Custom Scan Report for $DOMAIN
================================
Phase 1 Results: $(wc -l < "$OUTPUT_BASE/phase1/urls.txt") URLs found
Interesting URLs: $(echo "$INTERESTING" | wc -l)
EOF
```

---

## Tips and Tricks

### Tip 1: Speed Up Scans
```bash
# Use fewer tools for faster results
# Edit scan scripts to comment out slow tools
```

### Tip 2: Focus on Specific Vulnerabilities
```bash
# Extract only XSS-related URLs
cat scans/cool-example/urls.txt | grep "=" | dalfox pipe
```

### Tip 3: Integrate with Other Tools
```bash
# Feed results to custom tools
cat scans/cool-example/subdomains.txt | your-custom-tool
```

### Tip 4: Save Bandwidth
```bash
# Use light scan for local/staging environments
./cmd/scan_light -d localhost:8080
```

### Tip 5: Organize Results
```bash
# Use dated directories
OUTPUT_DIR="scans/$(date +%Y-%m-%d)/$DOMAIN"
./cmd/scan_cool -d "$DOMAIN" -o "$OUTPUT_DIR"
```

---

## Error Handling Examples

### Handle Failed Scans
```python
def safe_scan(domain, scan_type="light", retries=3):
    for attempt in range(retries):
        try:
            scan = start_scan(domain, scan_type)
            result = wait_for_completion(scan['scan_id'])
            
            if result['status'] == 'completed':
                return result
            else:
                print(f"Attempt {attempt + 1} failed, retrying...")
        except Exception as e:
            print(f"Error: {e}")
            time.sleep(10)
    
    return None
```

---

## Performance Optimization

### Parallel Scanning
```bash
#!/bin/bash

# Scan multiple domains in parallel
for domain in example1.com example2.com example3.com; do
  ./cmd/scan_light -d "$domain" -o "parallel/$domain" &
done

wait  # Wait for all to complete
echo "All scans completed!"
```

---

**For more examples and use cases, see:**
- [QUICKSTART.md](QUICKSTART.md) - Getting started
- [WEB_INTERFACE.md](WEB_INTERFACE.md) - Web interface guide
- [README.md](README.md) - Full documentation
