# GarudRecon - Complete Tool Installation & Testing Guide

## The Problem

When you run GarudRecon scans without installing reconnaissance tools first, you'll see results like this:

```
DNS Records: 0
Open Ports: 0
URLs Discovered: 0
XSS Findings: 0
SQLi Findings: 0
```

**This is EXPECTED behavior** - the scan scripts work correctly but have no tools to perform the actual reconnaissance.

## Solution: Install Tools First

### Step 1: Check What's Installed

```bash
./check_tools.sh
```

This shows exactly which tools you have and what's missing.

### Step 2: Choose Installation Method

#### Option A: Quick Install (Recommended)

Install essential tools for basic functionality (10-15 minutes):

```bash
sudo ./install_basic_tools.sh
```

This installs:
- **System tools**: dig, nmap, curl (for DNS, ports, HTTP)
- **Go tools**: httpx, subfinder, dnsx, naabu, nuclei, katana, waybackurls
- **Python tools**: sqlmap

After this, Light and Cool scans will produce real results.

#### Option B: Full Install

Install ALL 100+ tools for complete functionality (30-60 minutes):

```bash
# Requires root/sudo access
./garudrecon install -f ALL
```

### Step 3: Verify Installation

```bash
./check_tools.sh
```

Should now show many tools as installed (✓).

### Step 4: Test with Real Domain

```bash
# Create a test scan
./cmd/scan_light -d vianet.com.np -o test_scan

# View results
cat test_scan/results.json | python3 -m json.tool
cat test_scan/summary.txt
```

With tools installed, you should now see **real results** like:
```json
{
  "scan_type": "light",
  "domain": "vianet.com.np",
  "findings": {
    "dns_records": 2,
    "open_ports": 3,
    "urls_found": 150,
    "xss_findings": 0,
    "sqli_findings": 0
  },
  "status": "completed"
}
```

## Starting the Web Interface

The web interface will warn you if tools are missing:

```bash
./start_web.sh
```

Output will show:
```
========================================
   Checking Tools Installation
========================================

⚠️  WARNING: No reconnaissance tools installed!

Scans will complete but show 0 results.
To install basic tools, run:
  sudo ./install_basic_tools.sh
```

## Tool Requirements by Scan Type

### Light Scan - Minimum Tools Needed

For Light scan to produce results, install at least:

```bash
sudo apt install -y dnsutils nmap curl
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/tomnomnom/waybackurls@latest
```

Then test:
```bash
./cmd/scan_light -d example.com -o test1
```

### Cool Scan - Minimum Tools Needed

For Cool scan to work:

```bash
# All Light scan tools, plus:
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```

### Ultra Scan - Full Toolset

Requires most tools - use full install:
```bash
./garudrecon install -f ALL
```

## Real World Example

### Before Tool Installation:

```bash
$ ./cmd/scan_light -d vianet.com.np -o scan1
[2025-11-21 10:14:28] Starting LIGHT scan for vianet.com.np
[2025-11-21 10:14:28] [1/7] DNS Resolution...
[2025-11-21 10:14:28] [2/7] Port Scanning (common ports)...
[2025-11-21 10:14:28] Skipping port scan (nmap not found)
...

FINDINGS:
DNS Records: 0          ← No tools = no results
Open Ports: 0           ← No tools = no results
URLs Discovered: 0      ← No tools = no results
```

### After Installing Tools:

```bash
$ sudo ./install_basic_tools.sh
[+] Installing system packages...
[+] Installing Go tools...
  - httpx...
  - subfinder...
  ...
Installation complete!

$ ./cmd/scan_light -d vianet.com.np -o scan2
[2025-11-21 10:20:15] Starting LIGHT scan for vianet.com.np
[2025-11-21 10:20:15] [1/7] DNS Resolution...
[2025-11-21 10:20:15] Found 2 A records     ← Now getting results!
[2025-11-21 10:20:16] [2/7] Port Scanning...
[2025-11-21 10:20:22] Found 3 open ports    ← Now getting results!
[2025-11-21 10:20:23] [3/7] HTTP Probing...
[2025-11-21 10:20:24] HTTP probe complete
...

FINDINGS:
DNS Records: 2          ← Real results!
Open Ports: 3           ← Real results!
URLs Discovered: 147    ← Real results!
XSS Findings: 0
SQLi Findings: 0
```

## Common Issues

### Issue 1: "command not found" after installation

**Problem:** Tools installed but not in PATH

**Solution:**
```bash
export PATH=$PATH:$HOME/go/bin:/usr/local/go/bin
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
```

### Issue 2: Scans show 0 results

**Problem:** Tools not installed

**Solution:**
```bash
# Check what's missing
./check_tools.sh

# Install missing tools
sudo ./install_basic_tools.sh

# Verify
which httpx subfinder nuclei
```

### Issue 3: "Permission denied" during installation

**Problem:** Need root access for system packages

**Solution:**
```bash
sudo ./install_basic_tools.sh
# OR
sudo apt install -y dnsutils nmap curl
```

## Manual Tool Installation (Alternative)

If automated scripts don't work, install manually:

### 1. Install Go

```bash
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```

### 2. Install System Tools

```bash
sudo apt update
sudo apt install -y dnsutils nmap curl wget git jq python3 python3-pip
```

### 3. Install Go-Based Tools

```bash
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/tomnomnom/waybackurls@latest
```

### 4. Verify

```bash
httpx -version
subfinder -version
nuclei -version
```

## Testing Installation Success

Run this complete test:

```bash
#!/bin/bash
echo "Testing GarudRecon installation..."

# 1. Check tools
echo "1. Checking tools..."
./check_tools.sh | grep "Light Scan"

# 2. Run test scan
echo "2. Running test scan..."
./cmd/scan_light -d example.com -o /tmp/test_scan

# 3. Check results
echo "3. Checking results..."
python3 -m json.tool /tmp/test_scan/results.json

# 4. Look for non-zero values
DNS=$(jq '.findings.dns_records' /tmp/test_scan/results.json)
if [ "$DNS" -gt 0 ]; then
    echo "✓ SUCCESS: Tools are working! Found $DNS DNS records"
else
    echo "✗ FAIL: No results - tools may not be installed"
fi
```

## Quick Reference

| Command | Purpose |
|---------|---------|
| `./check_tools.sh` | See which tools are installed |
| `sudo ./install_basic_tools.sh` | Quick install (recommended) |
| `./garudrecon install -f ALL` | Full install (all tools) |
| `./start_web.sh` | Start web interface with warnings |
| `./cmd/scan_light -d domain.com -o output` | Test a scan |

## Summary

1. **Tools are NOT pre-installed** - GarudRecon is a framework that orchestrates external tools
2. **0 results = missing tools** - Scans complete successfully but have nothing to scan with
3. **Install tools first** - Use `sudo ./install_basic_tools.sh`
4. **Verify installation** - Use `./check_tools.sh`
5. **Test with real domain** - Results should show non-zero values

Without tools, scans are like a car without an engine - everything works, but you don't go anywhere! 🚗
