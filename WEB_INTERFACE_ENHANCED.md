# Enhanced Web Interface - Full Bug Bounty Scanning Tool

## 🚀 Overview

The CTXREC web interface has been completely redesigned to be a **full-featured bug bounty vulnerability scanning platform** with:

- ✅ **Auto-installation of all reconnaissance tools**
- ✅ **Beautiful, structured results display** (no more raw JSON!)
- ✅ **Real-time log streaming** with tool execution visibility
- ✅ **File viewer** to see discovered domains, URLs, and vulnerabilities
- ✅ **Enhanced design** with modern UI/UX
- ✅ **Tool status indicators** showing what's running
- ✅ **Color-coded logs** (errors, warnings, success)

---

## 🛠️ Auto Tool Installation

### Starting the Web Interface

Simply run:
```bash
sudo ./start_web.sh
```

**What happens automatically:**
1. ✅ Checks for missing tools (httpx, subfinder, nuclei, etc.)
2. ✅ Auto-installs ALL required tools (10-15 minutes)
3. ✅ Displays installation summary
4. ✅ Starts the web server on http://localhost:5000

### Required Tools by Scan Type

#### ⚡ Light Scan
- **dig** - DNS lookups
- **nmap** - Port scanning
- **httpx** - HTTP probing & tech detection
- **waybackurls** - Historical URL discovery
- **dalfox** - XSS vulnerability scanning
- **sqlmap** - SQL injection testing
- **curl** - HTTP requests

#### 🔥 Cool Scan (includes all Light tools +)
- **subfinder** - Subdomain enumeration
- **assetfinder** - Additional subdomain discovery
- **amass** - Advanced OSINT reconnaissance
- **dnsx** - DNS validation & resolution
- **naabu** - Fast port scanner
- **nuclei** - Vulnerability scanner (CVEs, misconfigs)
- **katana** - Web crawler

#### 🚀 Ultra Scan (includes all Cool tools +)
- **github-subdomains** - GitHub subdomain discovery
- **shosubgo** - Shodan subdomain search
- **crt.sh** - Certificate transparency logs
- **arjun** - Hidden parameter discovery
- **ffuf** - Web fuzzer
- **+20 more tools** for comprehensive scanning

---

## 🎨 Enhanced Results Display

### Before (Old UI)
```json
{
  "findings": {
    "dns_records": 1,
    "open_ports": 2,
    "urls_found": 0
  }
}
```

### After (New UI)

**Visual Summary Cards:**
```
┌───────────────┬───────────────┬───────────────┐
│ 🌐 DNS Records│ 🔌 Open Ports│ 🔗 URLs Found │
│      1        │      2        │      150      │
└───────────────┴───────────────┴───────────────┘

┌───────────────┬───────────────┬───────────────┐
│ ⚠️ XSS Issues │ 💉 SQLi Issues│ 🔥 Nuclei     │
│      3        │      0        │      12       │
└───────────────┴───────────────┴───────────────┘
```

**Clickable Files Section:**
```
📁 Generated Files
┌─────────────────────────────────┐
│ 📄 subdomains.txt (45 lines)    │ ← Click to view
│ 📄 urls.txt (150 lines)         │ ← Click to view
│ 📄 ports.txt (12 lines)         │ ← Click to view
│ 📄 xss_findings.txt (3 lines)   │ ← Click to view
│ 📄 nuclei_output.txt (12 lines) │ ← Click to view
└─────────────────────────────────┘
```

**Download Options:**
- 📥 Download Full Results (JSON)
- 📦 Download Individual Files

---

## 📊 Real-Time Log Streaming

### Enhanced Log Display

Logs are now **color-coded** and **tool-highlighted**:

```
▶ [1/7] DNS Resolution...
✓ Found 1 A records

▶ [2/7] Port Scanning (common ports)...
  Using tool: nmap
✓ Found 2 open ports

▶ [3/7] HTTP Probing...
  Using tool: httpx
✓ HTTP probe complete - 1 live hosts

⚠️ WARNING: dalfox not found, skipping XSS scan
❌ ERROR: Tool failed with exit code 1
```

**Color Legend:**
- 🟦 **Blue** - Step indicators
- 🟢 **Green** - Success messages
- 🟡 **Yellow** - Warnings
- 🔴 **Red** - Errors
- 🟣 **Purple** - Tool names (highlighted)

---

## 📁 File Viewer Feature

### View Files Directly in Browser

Click on any generated file to view its contents in a modal:

**Example: subdomains.txt**
```
www.example.com
api.example.com
admin.example.com
dev.example.com
staging.example.com
```

**Example: xss_findings.txt**
```
[HIGH] XSS Found: https://example.com/search?q=<script>alert(1)</script>
[MEDIUM] Reflected XSS: https://example.com/profile?name=<img src=x>
[LOW] Potential XSS: https://example.com/comment?text=<svg/onload=alert(1)>
```

**Example: nuclei_output.txt**
```
[CVE-2021-12345] WordPress Plugin Vulnerability - https://example.com
[misconfiguration] Apache Server Status Page Exposed - https://example.com/server-status
[info] Robots.txt Found - https://example.com/robots.txt
```

---

## 🎯 What's Fixed

### 1. Tool Installation Issues ✅
**Before:** Tools not installed, scans show 0 results  
**After:** Auto-installation on startup

### 2. Results Display ✅
**Before:** Raw JSON dump  
**After:** Beautiful cards with icons and numbers

### 3. File Visibility ✅
**Before:** Files created but not accessible  
**After:** Clickable file list with viewer

### 4. Log Details ✅
**Before:** Generic logs, can't see tool failures  
**After:** Color-coded, tool-highlighted, detailed logs

### 5. Tool Visibility ✅
**Before:** Don't know which tools are running  
**After:** Tool names shown in logs + scan type descriptions

---

## 🔧 Technical Implementation

### New Backend Endpoints

#### `GET /api/scan/<scan_id>/files`
Returns list of all generated files:
```json
{
  "files": [
    {"name": "urls.txt", "size": 12345, "lines": 150},
    {"name": "subdomains.txt", "size": 890, "lines": 45}
  ]
}
```

#### `GET /api/scan/<scan_id>/file/<filename>`
Returns file contents:
```json
{
  "filename": "urls.txt",
  "content": "https://example.com/page1\nhttps://example.com/page2",
  "lines": 2
}
```

### Frontend Enhancements

**New Functions:**
- `formatLogLine()` - Color-codes and highlights tool names
- `showResults()` - Creates visual summary cards
- `viewFile()` - Opens modal with file contents
- `checkToolStatus()` - Shows warning if tools missing

**New CSS Classes:**
- `.summary-card` - Result summary cards
- `.file-item` - Clickable file cards
- `.log-line.error/.warning/.success/.step` - Colored logs
- `.modal` - File viewer modal
- `.tool-warning-banner` - Tool missing alert

---

## 📖 Usage Examples

### Example 1: Light Scan

**Input:** `example.com`

**What Runs:**
1. ✓ dig → DNS resolution (1 record)
2. ✓ nmap → Port scan (ports 80, 443 open)
3. ✓ httpx → HTTP probe (tech: WordPress, Nginx)
4. ✓ waybackurls → URL discovery (150 URLs)
5. ✓ dalfox → XSS scan (3 vulnerabilities)
6. ✓ sqlmap → SQLi test (0 vulnerabilities)
7. ✓ curl → Security headers check

**Results Display:**
```
🌐 DNS: 1  🔌 Ports: 2  🔗 URLs: 150  ⚠️ XSS: 3  💉 SQLi: 0
```

**Files Created:**
- dns_a_records.txt
- ports.txt
- httpx.txt
- urls.txt
- xss_findings.txt
- results.json
- summary.txt

### Example 2: Cool Scan

**Input:** `bugcrowd.com`

**What Runs:**
1. ✓ subfinder → Find subdomains (45 found)
2. ✓ assetfinder → More subdomains (12 new)
3. ✓ amass → OSINT recon (8 new)
4. ✓ dnsx → Validate subdomains (60 live)
5. ✓ httpx → Probe all subdomains (55 live)
6. ✓ naabu → Port scan all hosts (120 open ports)
7. ✓ nuclei → CVE scan (12 vulnerabilities)
8. ✓ katana → Deep crawl (500+ URLs)
9. ✓ dalfox → XSS test
10. ✓ All Light scan features

**Results Display:**
```
🔎 Subdomains: 65  🌐 DNS: 60  🔌 Ports: 120  🔗 URLs: 500+
⚠️ XSS: 8  💉 SQLi: 2  🔥 Nuclei: 12
```

---

## 🚀 Quick Start

### Local Development
```bash
# Auto-install tools and start server
sudo ./start_web.sh

# Or manually
./garudrecon install -f ALL
python3 web_backend.py
```

### Access
Open browser: http://localhost:5000

### First Scan
1. Enter domain: `example.com`
2. Select scan type: Light
3. Click "Start Scan"
4. Watch real-time logs
5. View results in beautiful cards
6. Click files to view contents

---

## 🎓 Educational Use

This tool is perfect for:
- 🎯 **Bug Bounty Hunters** - Find vulnerabilities
- 🔒 **Penetration Testers** - Comprehensive recon
- 🎓 **Security Students** - Learn reconnaissance
- 💼 **Security Teams** - Asset discovery

**Tools You'll Learn:**
- Subdomain enumeration (subfinder, amass)
- Port scanning (nmap, naabu)
- Web probing (httpx)
- Vulnerability scanning (nuclei, dalfox, sqlmap)
- Web crawling (katana, waybackurls)

---

## ⚠️ Disclaimer

**Legal Notice:**
- Only scan domains you own or have permission to test
- Unauthorized scanning is illegal in most jurisdictions
- This tool is for educational and authorized security testing only
- The creators are not responsible for misuse

---

## 🤝 Contributing

Created by: **arjanchaudharyy**  
GitHub: https://github.com/arjanchaudharyy/GarudRecon

Improvements welcome:
- Additional tool integrations
- Better results parsing
- More visualization options
- Export to PDF/HTML reports

---

## 📝 Changelog

### Version 2.0 (Enhanced)
- ✅ Auto tool installation in start_web.sh
- ✅ Beautiful results display with cards
- ✅ File viewer with modal
- ✅ Color-coded logs with tool highlighting
- ✅ Tool usage descriptions in UI
- ✅ Warning banner for missing tools
- ✅ Download individual files
- ✅ Real-time progress tracking

### Version 1.0 (Original)
- Basic web interface
- JSON results display
- Simple log streaming

---

**Ready to hunt bugs? 🐛🔫**

Run `sudo ./start_web.sh` and start scanning!
