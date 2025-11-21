<h1 align="center">
  <img src="img/GarudRecon_banner2.png" alt="GarudRecon"></a>
</h1>

<p align="center">
<a href="#"><img src="https://madewithlove.org.in/badge.svg"></a>
<a href="https://ko-fi.com/rix4uni"><img src="https://img.shields.io/badge/buy%20me%20a%20ko--fi%20-donate-red"></a>
<a href="https://x.com/rix4uni"><img src="https://img.shields.io/badge/twitter-%40rix4uni-blue.svg"></a>
<a href="https://github.com/arjanchaudharyy/GarudRecon/issues"><img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat"></a>
<a href="https://github.com/arjanchaudharyy/GarudRecon/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg"></a>
<a href="#"><img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg"></a>
<a href="https://github.com/arjanchaudharyy?tab=followers"><img src="https://img.shields.io/badge/github-%40arjanchaudharyy-orange"></a>
</p>

## About GarudRecon

**GarudRecon** is an advanced reconnaissance automation framework designed for security professionals and bug bounty hunters. Built with Bash and powered by a modern Python Flask backend, it provides comprehensive asset discovery, vulnerability detection, and continuous monitoring capabilities.

**Created by:** [arjanchaudharyy](https://github.com/arjanchaudharyy)

### Key Features

- 🎯 **Comprehensive Vulnerability Scanning**
  - XSS (Cross-Site Scripting)
  - SQLi (SQL Injection)
  - LFI (Local File Inclusion)
  - RCE (Remote Code Execution)
  - Subdomain Takeover
  - Open Redirects
  - .git directory leaks
  - JavaScript secrets exposure
  - And much more

- 🌐 **Modern Web Interface** with real-time progress tracking
- ⚡ **Three Optimized Scan Modes** (Light, Cool, Ultra)
- 🔧 **60+ Security Tools Integration**
- 📊 **JSON-formatted Results** with download capability
- 🔄 **Continuous Monitoring** via cron jobs
- 🐳 **Docker Support** for easy deployment

## 🆕 Web Interface

GarudRecon now includes a modern web interface with three optimized scan modes:

- **⚡ Light** - Fast scan with basic reconnaissance (~5-10 minutes)
  - DNS resolution, port scanning, URL crawling, basic vulnerability checks
  
- **🔥 Cool** - Medium-level comprehensive scan (~20-30 minutes)
  - Subdomain enumeration, advanced port scanning, nuclei templates, parameter discovery
  
- **🚀 Ultra** - Full deep reconnaissance scan (~1-2 hours)
  - Complete asset discovery, extensive vulnerability scanning, JavaScript analysis

### Quick Start Web Interface

```bash
# Start the web server
./start_web.sh

# Or use the garudrecon command
./garudrecon web

# Access at: http://localhost:5000
```

**Features:**
- Real-time scan progress with live logs
- Scan history and results management
- One-click results download (JSON/TXT)
- Clean, responsive UI
- RESTful API for automation

📚 **Full Documentation**: [WEB_INTERFACE.md](WEB_INTERFACE.md)

## 🚀 Quick Deployment

### ☁️ FREE Cloud Deployment (Recommended for Beginners)

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/arjanchaudharyy/GarudRecon)

- No credit card required
- Always-on free tier
- Auto SSL & domain
- [See all free cloud options →](DEPLOY_FREE_CLOUD.md)

### 💻 Local/Development

```bash
./start_web.sh
```

### 🏭 Production VPS (Automated)

```bash
curl -fsSL https://raw.githubusercontent.com/arjanchaudharyy/GarudRecon/main/deployment/deploy.sh | sudo bash
```

### 🐳 Docker

```bash
docker-compose up -d
```

📦 **Full Deployment Guide**: [DEPLOYMENT.md](DEPLOYMENT.md)

## Installation

### Tool Requirements

⚠️ **Important**: GarudRecon requires external security tools to function. Without them, scans will show 0 results.

**Check & Install Tools:**

```bash
# Check which tools you have
./check_tools.sh

# Quick install (recommended - 10-15 minutes)
sudo ./install_basic_tools.sh

# OR full install (30-60 minutes)
./garudrecon install -f ALL
```

📖 **Complete Tool Setup Guide**: [TOOL_INSTALLATION_GUIDE.md](TOOL_INSTALLATION_GUIDE.md) - **START HERE**

### Easy Install (Recommended)

```bash
bash <(curl -s https://raw.githubusercontent.com/arjanchaudharyy/GarudRecon/main/configure)
```

### Using Git Clone

```bash
git clone --depth 1 https://github.com/arjanchaudharyy/GarudRecon.git
cd GarudRecon
sudo ./install_basic_tools.sh
```

### Download Pre-built Release

```bash
wget -q https://github.com/arjanchaudharyy/GarudRecon/archive/refs/tags/v0.0.6.zip
unzip v0.0.6.zip
cd GarudRecon-0.0.6
sudo ./install_basic_tools.sh
```

## CLI Usage

GarudRecon also provides powerful command-line interface for advanced users:

### Available Commands

```bash
garudrecon [command]

Commands:
  install         Set up tools and dependencies
  web             Start the web interface
  smallscope      Minimal recon for single subdomain (e.g. support.domain.com)
  mediumscope     Moderate recon for wildcard domain (e.g. *.domain.com)
  largescope      Full-scale recon for organization
  cronjobs        Automate recurring recon tasks
```

<details>
  <summary><b>garudrecon install -h</b></summary>

```
Install required tools and dependencies for reconnaissance functions.

Usage:
  garudrecon install [flags]

Flags:
  -f, --function        Function to run (e.g. MEDIUMSCOPE)
  -c, --config          Custom configuration file path
  -v, --verbose         Enable verbose mode
  -h, --help            Help for install

Example:
  garudrecon install -f SMALLSCOPE
  garudrecon install -f MEDIUMSCOPE
  garudrecon install -f LARGESCOPE
  garudrecon install -f ALL
```
</details>

<details>
  <summary><b>garudrecon smallscope -h</b></summary>

```
Minimal reconnaissance on a single subdomain (e.g. support.domain.com).
Includes port scanning, URL crawling, and vulnerability checks.

Usage:
  garudrecon smallscope [flags]

Flags:
  -d, --domain                Scan a domain (e.g. support.domain.com)
  -ef, --exclude-functions    Exclude functions (e.g. WAYMORE)
  -rx, --recon-xss            Run recon with XSS checks
  -rs, --recon-sqli           Run recon with SQLi checks
  -rl, --recon-lfi            Run recon with LFI checks
  -rst, --recon-subtakeover   Run recon with Subdomain Takeover checks
  -rr, --recon-rce            Run recon with RCE checks
  -ri, --recon-iis            Run recon with IIS checks
  -c, --config                Custom configuration file path
  -h, --help                  Help for smallscope

Examples:
  garudrecon smallscope -d support.domain.com
  garudrecon smallscope -d support.domain.com -rx
  garudrecon smallscope -d support.domain.com -ef "GOSPIDER,WAYMORE"
```
</details>

<details>
  <summary><b>garudrecon mediumscope -h</b></summary>

```
Medium-level reconnaissance on a wildcard domain (e.g. *.domain.com).
Includes subdomain enumeration and comprehensive vulnerability checks.

Usage:
  garudrecon mediumscope [flags]

Flags:
  -d, --domain                Scan a domain (e.g. domain.com)
  -ef, --exclude-functions    Exclude functions (e.g. AMASS)
  -rx, --recon-xss            Run recon with XSS checks
  -rs, --recon-sqli           Run recon with SQLi checks
  -rl, --recon-lfi            Run recon with LFI checks
  -rst, --recon-subtakeover   Run recon with Subdomain Takeover checks
  -rr, --recon-rce            Run recon with RCE checks
  -ri, --recon-iis            Run recon with IIS checks
  -oos, --outofscope          Exclude out-of-scope subdomains
  -c, --config                Custom configuration file path
  -h, --help                  Help for mediumscope

Examples:
  garudrecon mediumscope -d domain.com
  garudrecon mediumscope -d domain.com -rx
  garudrecon mediumscope -d domain.com -ef "SUBFINDER,AMASS"
```
</details>

<details>
  <summary><b>garudrecon cronjobs -h</b></summary>

```
Run scheduled reconnaissance tasks for continuous monitoring.

Usage:
  garudrecon cronjobs [flags]

Flags:
  -d, --domain      Domain to monitor
  -f, --function    Function to run (e.g. MONITOR_SUBDOMAIN)
  -c, --config      Custom configuration file path
  -i, --interval    Sleep duration between checks (e.g. 1800)
  -v, --verbose     Enable verbose mode
  -h, --help        Help for cronjobs

Examples:
  garudrecon cronjobs -d domain.com -f MONITOR_SUBDOMAIN
  garudrecon cronjobs -d domain.com -f MONITOR_PORTS
  garudrecon cronjobs -d domain.com -f MONITOR_ALIVESUBD
  garudrecon cronjobs -d domain.com -f MONITOR_JS
```
</details>

🚀 **Beginner Guide**: [QUICKSTART.md](QUICKSTART.md)

## Operating Systems Supported

| OS         | Supported | Easy Install | Tested        |
| ---------- | --------- | ------------ | ------------- |
| Ubuntu     | ✅        | ✅           | Ubuntu 24.04  |
| Kali       | ✅        | ✅           | Kali 2025.2   |
| Debian     | ✅        | ✅           | Debian 12     |
| Windows    | ✅        | ✅           | WSL Ubuntu    |
| MacOS      | ✅        | ✅           | macOS 14      |
| Arch Linux | ✅        | ⚠️           | Arch 2024     |

## System Requirements

Adjust settings based on your system's RAM:

| RAM   | Recommended Tools |
| ----- | ----------------- |
| 1GB   | Light mode only, disable AMASS, BBOT, FFUFBRUTE |
| 2GB   | Light + Cool mode, enable AMASS, PYXSS |
| 4GB   | All modes, enable VULNTECHX, GALER |
| 8GB+  | All features, full tool suite |

💡 Edit `configuration/garudrecon.cfg` and set `IS_U_USING_VPS="TRUE"` if running on a VPS.

## Integrated Security Tools (60+)

<details>
  <summary><b>View Complete Tool List</b></summary>

### Subdomain Enumeration
subfinder, amass, assetfinder, findomain, chaos, github-subdomains, bbot, oneforall, shosubgo, haktrails, subdog, xsubfind3r, org2asn, ipfinder, analyticsrelationships, udon, builtwithsubs, whoxysubs

### DNS & Certificate Tools
dnsx, puredns, shuffledns, massdns, kaeferjaeger, cero, certinfo, csprecon, jsubfinder, dnsxbrute, subwiz

### Subdomain Permutations
altdns, alterx, gotator, dnsgen, goaltdns, ripgen, dmut, subdomainfuzz

### Port Scanning
naabu, nmap, masscan, rustscan

### Web Probing
httpx, gowitness, aquatone, eyewitness

### URL Crawling & Discovery
waymore, hakrawler, waybackurls, katana, gau, gospider, cariddi, urlfinder, github-endpoints, xurlfind3r, xcrawl3r, galer, pathfinder, roboxtractor

### JavaScript Analysis
subjs, getJS, jscrawler, linkfinder, xnLinkFinder, getjswords, sourcemapper, jsluice, javascript-deobfuscator

### Directory Enumeration
ffuf, dirsearch, feroxbuster, wfuzz

### Parameter Discovery
paramfinder, x8, arjun

### Vulnerability Scanning
nuclei, dalfox (XSS), sqlmap (SQLi), commix (Command Injection), trufflehog (Secrets), shortscan, linkinspector

### Subdomain Takeover
subzy, nuclei templates

### Miscellaneous
favinfo (Favicon), gorker (Google Dorking), cewl (Wordlist Generator), s3scanner (S3 Buckets)

</details>

## Project Structure

```
GarudRecon/
├── garudrecon              # Main CLI entry point
├── cmd/                    # Scan mode executables
│   ├── scan_light         # Light scan mode
│   ├── scan_cool          # Cool scan mode
│   └── scan_ultra         # Ultra scan mode
├── web/                    # Web interface (HTML/CSS/JS)
├── web_backend.py          # Flask API server
├── start_web.sh            # Web server startup script
├── configuration/          # Configuration files
├── scans/                  # Scan results output (auto-created)
├── check_tools.sh          # Tool availability checker
├── install_basic_tools.sh  # Quick tool installer
└── docs/                   # Documentation
```

## API Endpoints

The Flask backend provides a RESTful API:

- `POST /api/scan` - Start a new scan
- `GET /api/scan/{id}` - Get scan status and results
- `GET /api/scans` - List all scans
- `GET /api/health` - Health check and tool status
- `GET /api/tools` - Check available tools

## Configuration

Edit `configuration/garudrecon.cfg` to customize:

- Tool preferences (enable/disable specific tools)
- VPS mode settings
- Output format preferences
- Notification settings (Discord, Slack, Telegram)
- Custom wordlists and API keys

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

GarudRecon is licensed under the MIT License. See [LICENSE](LICENSE) for details.

**Original Author**: [rix4uni](https://github.com/rix4uni)  
**Current Maintainer**: [arjanchaudharyy](https://github.com/arjanchaudharyy)

## Acknowledgments

This project leverages numerous open-source security tools created by the amazing infosec community. See [docs/Thanks.md](docs/Thanks.md) for the complete list of tool authors.

## Support

- 📖 **Documentation**: Check the docs/ folder for detailed guides
- 🐛 **Issues**: [GitHub Issues](https://github.com/arjanchaudharyy/GarudRecon/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/arjanchaudharyy/GarudRecon/discussions)
- ☕ **Donate**: [Ko-fi](https://ko-fi.com/rix4uni)

## Disclaimer

This tool is intended for authorized security testing and educational purposes only. Users are responsible for ensuring they have proper authorization before scanning any targets. Unauthorized access to computer systems is illegal.

---

<p align="center">Made with ❤️ for the security community</p>
