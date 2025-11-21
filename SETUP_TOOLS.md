# GarudRecon - Tool Setup Guide

## Overview

GarudRecon relies on various security testing tools to perform reconnaissance and vulnerability scanning. This guide will help you install the required tools.

## Quick Check

To see which tools are currently installed:

```bash
./check_tools.sh
```

## Installation Options

### Option 1: Install Basic Tools (Recommended for Testing)

Install minimal tools needed for Light scans (5-10 minutes):

```bash
sudo ./install_basic_tools.sh
```

This installs:
- **System tools**: dig, nmap, curl, wget, jq
- **Go tools**: httpx, subfinder, dnsx, naabu, nuclei, katana, waybackurls
- **Python tools**: sqlmap

### Option 2: Install All Tools (Full Installation)

For complete functionality with all scan modes (30-60 minutes):

```bash
./garudrecon install -f ALL
```

This installs 100+ tools for comprehensive reconnaissance.

### Option 3: Install Per Scan Type

Install tools for specific scan modes:

```bash
# For Light scans only
./garudrecon install -f SMALLSCOPE

# For Cool scans
./garudrecon install -f MEDIUMSCOPE

# For Ultra scans
./garudrecon install -f LARGESCOPE
```

## Tool Requirements by Scan Type

### Light Scan (Fast - 5-10 minutes)
**Minimum Required:**
- `dig` - DNS resolution
- `curl` - HTTP requests

**Recommended:**
- `nmap` - Port scanning
- `httpx` - HTTP probing
- `waybackurls` or `gau` - URL discovery
- `dalfox` - XSS testing
- `sqlmap` - SQLi testing

### Cool Scan (Medium - 20-30 minutes)
**Required:**
- `subfinder` or `assetfinder` - Subdomain enumeration
- `dnsx` - DNS resolution
- `httpx` - HTTP probing
- `naabu` or `nmap` - Port scanning

**Recommended:**
- `amass` - Advanced subdomain enum
- `waybackurls`, `gau`, `katana` - URL discovery
- `subjs` - JavaScript file discovery
- `dalfox` - XSS testing
- `sqlmap` - SQLi testing
- `nuclei` - Vulnerability scanning
- `subzy` - Subdomain takeover checks

### Ultra Scan (Comprehensive - 1-2 hours)
**Required:** All tools from Light + Cool, plus:
- `findomain`, `chaos`, `cero` - Additional subdomain sources
- `alterx` or `altdns` - Subdomain permutation
- `puredns` - Advanced DNS resolution
- `masscan` - Fast port scanning
- `hakrawler`, `gospider` - Web crawling
- `linkfinder` - JavaScript endpoint extraction
- `paramspider` - Parameter discovery
- `ffuf` - Directory fuzzing
- `gowitness` or `aquatone` - Screenshots

## Manual Installation Examples

### Install Go (if not installed)

```bash
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
```

### Install Individual Tools

```bash
# Go-based tools
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# System packages
sudo apt install -y dnsutils nmap curl wget jq

# Python tools
pip3 install sqlmap
```

## Verify Installation

After installing tools:

```bash
# Check all tools
./check_tools.sh

# Test with a real scan
./cmd/scan_light -d example.com -o test_scan

# Check the results
cat test_scan/results.json
```

## Troubleshooting

### "No tools found" or "0 results"

If scans complete but show 0 results:
1. Run `./check_tools.sh` to see which tools are missing
2. Install missing tools using one of the methods above
3. Ensure tools are in your PATH: `echo $PATH`
4. Verify tool installation: `which httpx subfinder nuclei`

### "Permission denied"

If you get permission errors:
- Make sure scripts are executable: `chmod +x cmd/scan_*`
- Run install scripts with sudo: `sudo ./install_basic_tools.sh`

### Go tools not found after installation

Add Go bin to PATH:
```bash
export PATH=$PATH:$HOME/go/bin
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
```

## Running Without All Tools

The scan scripts are designed to work even with missing tools:
- They will skip steps where tools are unavailable
- Results will show 0 for areas that couldn't be scanned
- Check logs to see which tools were skipped

**Example:** If you only have `dig` and `curl`, Light scan will:
- ✓ Perform DNS resolution
- ✓ Check security headers
- ✗ Skip port scanning (needs nmap)
- ✗ Skip URL discovery (needs waybackurls/gau)
- ✗ Skip vulnerability checks (needs dalfox/sqlmap)

## Production Deployment

For production use, install all tools:

```bash
# 1. Install system dependencies
sudo apt update
sudo apt install -y build-essential git curl wget

# 2. Install Go
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz

# 3. Set up environment
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

# 4. Install all GarudRecon tools
./garudrecon install -f ALL

# 5. Verify installation
./check_tools.sh
```

## Notes

- Tool installation can take significant disk space (1-2 GB)
- Some tools require root/sudo access for packet capture features
- Not all tools are required - scans adapt to available tools
- Update tools regularly: `go install -u <tool>@latest`

## Support

If you encounter issues:
1. Check `./check_tools.sh` output
2. Review scan logs in `scans/<scan-id>/`
3. Verify PATH contains Go bin: `echo $PATH`
4. Check tool versions: `httpx -version`, `nuclei -version`, etc.
