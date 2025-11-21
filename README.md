# CTXREC

<p align="center">
<a href="#"><img src="https://img.shields.io/badge/Made%20with-Bash%20%26%20Python-blue.svg"></a>
<a href="https://github.com/arjanchaudharyy/GarudRecon/issues"><img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat"></a>
<a href="https://github.com/arjanchaudharyy/GarudRecon/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg"></a>
<a href="https://github.com/arjanchaudharyy?tab=followers"><img src="https://img.shields.io/badge/github-%40arjanchaudharyy-orange"></a>
</p>

---

## 🎯 About CTXREC

**CTXREC** (Context Reconnaissance) is a cutting-edge automated reconnaissance framework built for security professionals, penetration testers, and bug bounty hunters. Combining the power of Bash automation with a modern Python Flask web interface, CTXREC delivers comprehensive asset discovery, vulnerability detection, and continuous monitoring in one unified platform.

**Developed by:** [arjanchaudharyy](https://github.com/arjanchaudharyy)

---

## ✨ Key Features

### 🔍 Comprehensive Reconnaissance
- **Subdomain Discovery** - Advanced enumeration using 15+ tools
- **Port Scanning** - Fast and accurate with multiple scanning engines
- **URL Crawling** - Deep web crawling and endpoint discovery
- **JavaScript Analysis** - Extract secrets, endpoints, and API keys
- **DNS Enumeration** - Certificate transparency and DNS bruteforcing
- **Parameter Discovery** - Hidden parameter and endpoint fuzzing

### 🛡️ Vulnerability Detection
- ✅ **XSS (Cross-Site Scripting)** - Automated payload testing
- ✅ **SQL Injection** - Database vulnerability scanning
- ✅ **LFI/RFI** - File inclusion vulnerability checks
- ✅ **RCE** - Remote code execution detection
- ✅ **Subdomain Takeover** - Identify dangling DNS records
- ✅ **Open Redirects** - Unvalidated redirect detection
- ✅ **SSRF** - Server-side request forgery scanning
- ✅ **Secret Exposure** - API keys, tokens, credentials in JS/HTML
- ✅ **.git Directory Leaks** - Exposed repository detection
- ✅ **CORS Misconfiguration** - Cross-origin policy issues

### 🌐 Modern Web Interface
- 📊 **Real-time Dashboard** - Live scan progress monitoring
- 📈 **Visual Analytics** - Comprehensive result visualization
- 🔄 **Scan History** - Track and compare historical scans
- 📥 **Export Results** - Download in JSON, CSV, or TXT format
- 🎨 **Responsive Design** - Works on desktop and mobile
- 🔔 **Notifications** - Discord, Slack, Telegram integration

### ⚡ Three Optimized Scan Modes
- **🚀 Light Mode** (~5-10 minutes) - Quick reconnaissance for rapid assessment
- **💪 Cool Mode** (~20-30 minutes) - Balanced depth and speed
- **🔥 Ultra Mode** (~1-2 hours) - Comprehensive deep-dive analysis

### 🔧 Advanced Capabilities
- 🐳 **Docker Support** - Containerized deployment
- 📡 **API Access** - RESTful API for automation
- ⏰ **Continuous Monitoring** - Scheduled cron jobs
- 🎯 **Custom Scopes** - Flexible inclusion/exclusion rules
- 📋 **60+ Tool Integration** - Best-in-class security tools
- 🔐 **Secure by Design** - Built with security best practices

---

## 🚀 Quick Start

### Web Interface (Recommended)

```bash
# Start the web interface
./start_web.sh

# Access the dashboard at:
# http://localhost:5000
```

That's it! Open your browser and start scanning immediately.

### Command Line Interface

```bash
# Simple scan
./ctxrec -d example.com

# Advanced scan with all vulnerability checks
./ctxrec -d example.com --vuln-all

# Light mode scan
./ctxrec light -d example.com
```

---

## 📦 Installation

### Method 1: Quick Install (Recommended)

```bash
# Clone the repository
git clone https://github.com/arjanchaudharyy/GarudRecon.git
cd GarudRecon

# Install essential tools (takes 10-15 minutes)
sudo ./install_basic_tools.sh

# Start using CTXREC
./start_web.sh
```

### Method 2: One-Line Install

```bash
bash <(curl -s https://raw.githubusercontent.com/arjanchaudharyy/GarudRecon/main/configure)
```

### Method 3: Docker (Production Ready)

```bash
# Using Docker Compose
docker-compose up -d

# Access at http://localhost:5000
```

### Method 4: Manual Installation

```bash
# Download latest release
wget https://github.com/arjanchaudharyy/GarudRecon/archive/refs/tags/v0.0.6.zip
unzip v0.0.6.zip
cd GarudRecon-0.0.6

# Check required tools
./check_tools.sh

# Install all tools
sudo ./install_basic_tools.sh
```

---

## ☁️ Cloud Deployment

### Deploy to Render (Free - No Credit Card)

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/arjanchaudharyy/GarudRecon)

**Why Render?**
- ✅ 100% Free tier (no credit card required)
- ✅ Auto SSL certificate
- ✅ Custom domain support
- ✅ Always-on instances
- ✅ Automatic deployments from GitHub

### Other Free Cloud Options

<details>
  <summary><b>Railway</b></summary>

```bash
# Install Railway CLI
npm i -g @railway/cli

# Deploy
railway login
railway init
railway up
```
</details>

<details>
  <summary><b>Fly.io</b></summary>

```bash
# Install Fly CLI
curl -L https://fly.io/install.sh | sh

# Deploy
fly launch
fly deploy
```
</details>

<details>
  <summary><b>Heroku</b></summary>

```bash
# Install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh

# Deploy
heroku create your-ctxrec-app
git push heroku main
```
</details>

### VPS Deployment (Automated)

For production VPS deployment with Nginx, SSL, and systemd:

```bash
# One-command deployment
curl -fsSL https://raw.githubusercontent.com/arjanchaudharyy/GarudRecon/main/deployment/deploy.sh | sudo bash
```

This will:
- Install all dependencies
- Set up Nginx reverse proxy
- Configure SSL with Let's Encrypt
- Create systemd service
- Configure firewall
- Set up auto-restart on failure

📖 **Complete Deployment Guide**: [DEPLOYMENT.md](DEPLOYMENT.md)

---

## 🎮 How CTXREC Works

### Scan Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  1. Domain Input                                            │
│     └─> example.com                                         │
└─────────────────────────────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  2. Subdomain Enumeration                                   │
│     ├─> DNS Bruteforcing (5+ tools)                        │
│     ├─> Certificate Transparency                           │
│     ├─> Search Engines (Google, Bing, etc)                 │
│     └─> Third-party APIs (Shodan, Censys, etc)             │
└─────────────────────────────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  3. DNS Resolution & Filtering                              │
│     └─> Verify active subdomains                           │
└─────────────────────────────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  4. Port Scanning                                           │
│     ├─> Common ports (80, 443, 8080, etc)                  │
│     ├─> Service detection                                  │
│     └─> Banner grabbing                                    │
└─────────────────────────────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  5. Web Probing                                             │
│     ├─> HTTP/HTTPS detection                               │
│     ├─> Technology fingerprinting                          │
│     └─> Response analysis                                  │
└─────────────────────────────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  6. URL & Endpoint Discovery                                │
│     ├─> Wayback Machine archives                           │
│     ├─> CommonCrawl data                                   │
│     ├─> Spider crawling                                    │
│     └─> JavaScript parsing                                 │
└─────────────────────────────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  7. Vulnerability Scanning                                  │
│     ├─> XSS injection points                               │
│     ├─> SQL injection testing                              │
│     ├─> LFI/RFI attempts                                   │
│     ├─> RCE detection                                      │
│     ├─> Subdomain takeover checks                          │
│     └─> Secret exposure analysis                           │
└─────────────────────────────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  8. Results & Reporting                                     │
│     ├─> JSON export                                        │
│     ├─> HTML report                                        │
│     ├─> Notifications                                      │
│     └─> Database storage                                   │
└─────────────────────────────────────────────────────────────┘
```

### Scan Modes Explained

#### ⚡ Light Mode (Fast)
**Time:** 5-10 minutes  
**Best for:** Quick checks, bug bounty triage, initial reconnaissance

**What it does:**
- Basic subdomain enumeration (2-3 tools)
- Essential port scanning (top 100 ports)
- URL crawling (waybackurls, gau)
- Quick XSS/SQLi checks
- JavaScript secrets scanning

**Output:** DNS records, open ports, URLs, basic vulnerabilities

---

#### 💪 Cool Mode (Balanced)
**Time:** 20-30 minutes  
**Best for:** Thorough reconnaissance, most bug bounty programs

**What it does:**
- Comprehensive subdomain enumeration (10+ tools)
- Full port scanning (top 1000 ports)
- Deep URL crawling (multiple sources)
- Advanced vulnerability scanning
- Parameter discovery
- Directory bruteforcing
- Nuclei template scanning

**Output:** Complete asset inventory, detailed vulnerabilities, endpoints

---

#### 🔥 Ultra Mode (Deep)
**Time:** 1-2 hours  
**Best for:** Pentest engagements, comprehensive audits, large targets

**What it does:**
- All Cool Mode features +
- Subdomain permutation attacks
- Full port scanning (65535 ports)
- Extensive JS analysis
- VHOST discovery
- Favicon analysis
- Screenshot capture
- Full directory enumeration
- Extensive nuclei scanning
- All vulnerability checks enabled

**Output:** Exhaustive reconnaissance data, maximum vulnerability coverage

---

## 💻 Web Interface Features

### Dashboard
- 📊 Live scan progress with percentage complete
- 📈 Real-time statistics (subdomains, URLs, vulnerabilities)
- 🔴 Live log streaming
- 🎯 Quick action buttons

### Scan Management
- ▶️ Start new scans with custom options
- ⏸️ Pause/Resume running scans
- ⏹️ Stop scans
- 🗑️ Delete old scan results
- 📥 Download results in multiple formats

### Results Viewer
- 🔍 Filter and search results
- 📋 Categorized findings
- 🎨 Syntax highlighting for code/URLs
- 📊 Visual charts and graphs
- 🔗 One-click copy to clipboard

### Settings
- ⚙️ Configure tool preferences
- 🔔 Set up notifications (Discord, Slack, Telegram)
- 🎯 Define custom wordlists
- 🔑 Add API keys (Shodan, Censys, etc)
- 💾 Export/Import configurations

---

## 📡 API Documentation

CTXREC provides a RESTful API for automation and integration:

### Authentication
```bash
# No authentication required for local use
# For production, set API_KEY in environment
export CTXREC_API_KEY="your-secret-key"
```

### Endpoints

#### Start a Scan
```bash
POST /api/scan
Content-Type: application/json

{
  "domain": "example.com",
  "scan_mode": "cool",
  "options": {
    "enable_xss": true,
    "enable_sqli": true,
    "depth": "medium"
  }
}

# Response
{
  "scan_id": "abc123",
  "status": "started",
  "estimated_time": "20-30 minutes"
}
```

#### Get Scan Status
```bash
GET /api/scan/{scan_id}

# Response
{
  "scan_id": "abc123",
  "status": "running",
  "progress": 45,
  "stats": {
    "subdomains": 127,
    "urls": 3421,
    "vulnerabilities": 12
  }
}
```

#### List All Scans
```bash
GET /api/scans

# Response
{
  "scans": [
    {
      "id": "abc123",
      "domain": "example.com",
      "mode": "cool",
      "status": "completed",
      "started_at": "2025-01-15T10:30:00Z",
      "completed_at": "2025-01-15T10:52:00Z"
    }
  ]
}
```

#### Get Scan Results
```bash
GET /api/scan/{scan_id}/results

# Response (JSON with complete scan data)
{
  "domain": "example.com",
  "subdomains": [...],
  "urls": [...],
  "vulnerabilities": [...]
}
```

#### Health Check
```bash
GET /api/health

# Response
{
  "status": "healthy",
  "version": "1.0.0",
  "tools_available": 52,
  "active_scans": 2
}
```

#### Check Available Tools
```bash
GET /api/tools

# Response
{
  "installed": ["subfinder", "httpx", "nuclei", ...],
  "missing": ["amass", "bbot"],
  "total": 60
}
```

---

## 🔧 Configuration

### Basic Configuration

Edit `configuration/ctxrec.cfg`:

```bash
# VPS Mode (reduces memory usage)
IS_U_USING_VPS="FALSE"  # Set to TRUE for VPS

# Notification Settings
DISCORD_WEBHOOK=""
SLACK_WEBHOOK=""
TELEGRAM_BOT_TOKEN=""
TELEGRAM_CHAT_ID=""

# API Keys (optional but recommended)
SHODAN_API_KEY=""
CENSYS_API_ID=""
CENSYS_API_SECRET=""
GITHUB_TOKEN=""

# Tool Preferences
ENABLE_AMASS="TRUE"
ENABLE_BBOT="TRUE"
ENABLE_NUCLEI="TRUE"

# Scan Settings
DEFAULT_THREADS=20
TIMEOUT=300
MAX_RETRIES=3
```

### Advanced Configuration

<details>
  <summary><b>Custom Wordlists</b></summary>

```bash
# Subdomain wordlist
SUBDOMAIN_WORDLIST="/path/to/subdomains.txt"

# Directory wordlist
DIRECTORY_WORDLIST="/path/to/directories.txt"

# Parameter wordlist
PARAMETER_WORDLIST="/path/to/parameters.txt"
```
</details>

<details>
  <summary><b>Exclusion Rules</b></summary>

```bash
# Exclude specific subdomains
OUT_OF_SCOPE="admin.example.com,vpn.example.com"

# Exclude tools
EXCLUDE_TOOLS="amass,bbot"

# Exclude vulnerability checks
EXCLUDE_VULNS="sqli,rce"
```
</details>

<details>
  <summary><b>Output Settings</b></summary>

```bash
# Output directory
OUTPUT_DIR="./scans"

# Output format
OUTPUT_FORMAT="json"  # json, csv, txt, html

# Keep raw tool outputs
KEEP_RAW_OUTPUT="TRUE"

# Compress results
COMPRESS_RESULTS="TRUE"
```
</details>

---

## 🖥️ System Requirements

### Minimum Requirements
- **OS:** Linux (Ubuntu 20.04+, Kali, Debian)
- **RAM:** 2GB (Light mode only)
- **Storage:** 5GB free space
- **CPU:** 2 cores

### Recommended for Full Features
- **OS:** Ubuntu 24.04 / Kali 2025
- **RAM:** 4GB+ (8GB for Ultra mode)
- **Storage:** 20GB+ free space
- **CPU:** 4+ cores
- **Network:** Stable internet connection

### RAM-Based Tool Configuration

| RAM | Recommended Configuration |
|-----|---------------------------|
| **1GB** | Light mode only. Disable: AMASS, BBOT, FFUFBRUTE |
| **2GB** | Light + Cool modes. Enable: AMASS, PYXSS |
| **4GB** | All modes. Enable: VULNTECHX, GALER |
| **8GB+** | Full tool suite with maximum concurrency |

---

## 🐧 Operating System Support

| OS | Status | Installation | Tested Version |
|----|--------|--------------|----------------|
| **Ubuntu** | ✅ Fully Supported | `sudo ./install_basic_tools.sh` | 24.04 LTS |
| **Kali Linux** | ✅ Fully Supported | `sudo ./install_basic_tools.sh` | 2025.2 |
| **Debian** | ✅ Fully Supported | `sudo ./install_basic_tools.sh` | 12 (Bookworm) |
| **Arch Linux** | ✅ Supported | Manual (see docs) | Rolling |
| **macOS** | ✅ Supported | `./install_basic_tools.sh` | 14+ (Sonoma) |
| **Windows** | ✅ Via WSL | WSL2 + Ubuntu | WSL2 |
| **Docker** | ✅ Recommended | `docker-compose up` | Any OS |

---

## 🛠️ Integrated Security Tools (60+)

CTXREC integrates the best open-source security tools:

<details>
  <summary><b>📡 Subdomain Enumeration (18 tools)</b></summary>

- **subfinder** - Fast passive subdomain enumeration
- **amass** - In-depth DNS enumeration and network mapping
- **assetfinder** - Find domains and subdomains
- **findomain** - Fast cross-platform subdomain enumerator
- **chaos** - ProjectDiscovery's subdomain dataset
- **github-subdomains** - Search GitHub for subdomains
- **bbot** - Recursive internet scanner
- **oneforall** - Powerful subdomain collection tool
- **shosubgo** - Shodan-based subdomain finder
- **haktrails** - SecurityTrails subdomain enumeration
- **subdog** - DNS subdomain scanner
- **xsubfind3r** - Fast subdomain scanner
- **org2asn** - Organization to ASN mapping
- **ipfinder** - IP and domain information
- **analyticsrelationships** - Find related domains
- **udon** - Domain OSINT tool
- **builtwithsubs** - BuiltWith subdomain finder
- **whoxysubs** - WHOXY API integration
</details>

<details>
  <summary><b>🔐 DNS & Certificate Tools (11 tools)</b></summary>

- **dnsx** - Fast DNS toolkit
- **puredns** - Fast domain resolver
- **shuffledns** - Wrapper around massdns
- **massdns** - High-performance DNS resolver
- **kaeferjaeger** - Certificate transparency monitor
- **cero** - Certificate transparency scanner
- **certinfo** - Certificate information extractor
- **csprecon** - CSP header analyzer
- **jsubfinder** - JS subdomain finder
- **dnsxbrute** - DNS bruteforcer
- **subwiz** - DNS record analyzer
</details>

<details>
  <summary><b>🔄 Subdomain Permutations (8 tools)</b></summary>

- **altdns** - Subdomain permutation generator
- **puredns** - DNS resolver with wildcard filtering
- **alterx** - Fast subdomain wordlist generator
- **gotator** - Subdomain permutation tool
- **dnsgen** - Generate DNS permutations
- **goaltdns** - Permutation generator in Go
- **ripgen** - Permutation wordlist generator
- **dmut** - Fast DNS resolver
</details>

<details>
  <summary><b>🔍 Port Scanning (4 tools)</b></summary>

- **naabu** - Fast port scanner by ProjectDiscovery
- **nmap** - Network exploration tool
- **masscan** - Fastest port scanner
- **rustscan** - Modern port scanner
</details>

<details>
  <summary><b>🌐 Web Probing (4 tools)</b></summary>

- **httpx** - Fast HTTP toolkit
- **gowitness** - Web screenshot utility
- **aquatone** - Visual inspection tool
- **eyewitness** - Screenshot web applications
</details>

<details>
  <summary><b>🔗 URL Discovery (15 tools)</b></summary>

- **waymore** - Wayback Machine downloader
- **hakrawler** - Fast web crawler
- **waybackurls** - Wayback Machine URL fetcher
- **katana** - Next-gen crawling framework
- **gau** - Get All URLs
- **gospider** - Fast web spider
- **cariddi** - Crawler with secrets detection
- **urlfinder** - Extract URLs from files
- **github-endpoints** - GitHub endpoint finder
- **xurlfind3r** - URL discovery tool
- **xcrawl3r** - Web crawler
- **galer** - Fast URL fetcher
- **pathfinder** - Path discovery tool
- **roboxtractor** - Extract robots.txt URLs
</details>

<details>
  <summary><b>📜 JavaScript Analysis (9 tools)</b></summary>

- **subjs** - Fetch JavaScript files
- **getJS** - JavaScript file downloader
- **jscrawler** - JS file crawler
- **linkfinder** - Discover endpoints in JS
- **xnLinkFinder** - Advanced JS endpoint finder
- **getjswords** - Extract words from JS
- **sourcemapper** - JS source map analyzer
- **jsluice** - Extract URLs from JS
- **javascript-deobfuscator** - Deobfuscate JS code
</details>

<details>
  <summary><b>📂 Directory Enumeration (4 tools)</b></summary>

- **ffuf** - Fast web fuzzer
- **dirsearch** - Web path scanner
- **feroxbuster** - Fast content discovery
- **wfuzz** - Web application fuzzer
</details>

<details>
  <summary><b>🔎 Parameter Discovery (3 tools)</b></summary>

- **paramfinder** - Parameter miner
- **x8** - Hidden parameter discovery
- **arjun** - HTTP parameter scanner
</details>

<details>
  <summary><b>⚠️ Vulnerability Scanning (8 tools)</b></summary>

- **nuclei** - Fast vulnerability scanner (1000+ templates)
- **dalfox** - Advanced XSS scanner
- **sqlmap** - SQL injection exploitation
- **commix** - Command injection toolkit
- **trufflehog** - Secret scanner
- **shortscan** - Quick vulnerability checker
- **linkinspector** - Link analyzer
- **subzy** - Subdomain takeover scanner
</details>

---

## 📊 Project Structure

```
CTXREC/
├── ctxrec                      # Main CLI entry point
├── garudrecon                  # Legacy CLI (symlink)
├── start_web.sh                # Web server launcher
├── web_backend.py              # Flask API server
│
├── cmd/                        # Scan mode scripts
│   ├── scan_light             # Light scan implementation
│   ├── scan_cool              # Cool scan implementation
│   └── scan_ultra             # Ultra scan implementation
│
├── web/                        # Frontend files
│   ├── index.html             # Main dashboard
│   ├── style.css              # Styling
│   └── script.js              # Frontend logic
│
├── configuration/              # Configuration files
│   └── ctxrec.cfg             # Main config file
│
├── scans/                      # Scan output directory
│   └── [domain]/              # Per-domain results
│       ├── results.json       # Structured results
│       ├── subdomains.txt     # Discovered subdomains
│       ├── urls.txt           # Found URLs
│       └── vulnerabilities.txt # Detected issues
│
├── tools/                      # Security tool installers
├── wordlists/                  # Custom wordlists
├── templates/                  # Nuclei templates
├── docs/                       # Documentation
│
├── check_tools.sh              # Verify installed tools
├── install_basic_tools.sh      # Quick installer
├── requirements.txt            # Python dependencies
├── docker-compose.yml          # Docker configuration
└── Dockerfile                  # Docker image definition
```

---

## 🎓 Usage Examples

### Example 1: Quick Bug Bounty Scan
```bash
# Fast scan for quick triage
./ctxrec light -d bugcrowd-target.com

# Results in: scans/bugcrowd-target.com/results.json
```

### Example 2: Comprehensive Pentest
```bash
# Full deep scan with all checks
./ctxrec ultra -d client-target.com --vuln-all

# Enable notifications
export DISCORD_WEBHOOK="your-webhook-url"
```

### Example 3: Continuous Monitoring
```bash
# Monitor for new subdomains every hour
./ctxrec cronjobs -d important-target.com \
  -f MONITOR_SUBDOMAIN \
  -i 3600
```

### Example 4: API Automation
```bash
# Start scan via API
curl -X POST http://localhost:5000/api/scan \
  -H "Content-Type: application/json" \
  -d '{
    "domain": "example.com",
    "scan_mode": "cool"
  }'

# Check status
curl http://localhost:5000/api/scan/abc123
```

### Example 5: Custom Configuration
```bash
# Use custom config and wordlists
./ctxrec cool -d target.com \
  -c ~/my-config.cfg \
  --subdomain-wordlist ~/subdomains.txt \
  --exclude-tools "amass,bbot"
```

---

## 🔒 Security & Privacy

CTXREC is built with security in mind:

- ✅ **No data collection** - All scans are local
- ✅ **No telemetry** - Zero tracking or analytics
- ✅ **Open source** - Fully auditable code
- ✅ **API key protection** - Credentials stored securely
- ✅ **Rate limiting** - Respects target servers
- ✅ **User-agent rotation** - Avoid detection/blocking

**Ethical Use Only:** CTXREC is intended for authorized security testing only. Users are responsible for obtaining proper authorization before scanning any targets.

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Reporting Issues
- 🐛 Bug reports: [GitHub Issues](https://github.com/arjanchaudharyy/GarudRecon/issues)
- 💡 Feature requests: [GitHub Discussions](https://github.com/arjanchaudharyy/GarudRecon/discussions)

### Contributing Code
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup
```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/GarudRecon.git
cd GarudRecon

# Install dependencies
pip3 install -r requirements.txt

# Run in development mode
python3 web_backend.py
```

📖 See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📚 Documentation

- **📖 [QUICKSTART.md](QUICKSTART.md)** - Beginner-friendly guide
- **🌐 [WEB_INTERFACE.md](WEB_INTERFACE.md)** - Web dashboard documentation
- **🔧 [TOOL_INSTALLATION_GUIDE.md](TOOL_INSTALLATION_GUIDE.md)** - Complete tool setup
- **📦 [DEPLOYMENT.md](DEPLOYMENT.md)** - Production deployment guide
- **☁️ [DEPLOY_FREE_CLOUD.md](DEPLOY_FREE_CLOUD.md)** - Free cloud hosting options
- **🐛 [BUGFIX_SUMMARY.md](BUGFIX_SUMMARY.md)** - Recent fixes and improvements
- **📝 [CHANGELOG.md](CHANGELOG.md)** - Version history

---

## 📝 License

CTXREC is released under the **MIT License**.

```
MIT License

Copyright (c) 2025 arjanchaudharyy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

CTXREC stands on the shoulders of giants. We're grateful to the security community and the creators of all integrated tools:

- **ProjectDiscovery Team** - subfinder, httpx, nuclei, katana, naabu
- **OWASP** - ZAP, sqlmap
- **Tom Hudson (tomnomnom)** - waybackurls, httprobe, assetfinder
- **Jeff Foley** - amass
- **And many more...**

See [docs/Thanks.md](docs/Thanks.md) for the complete list.

---

## 💬 Support & Community

- 📖 **Documentation**: Browse the `/docs` folder
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/arjanchaudharyy/GarudRecon/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/arjanchaudharyy/GarudRecon/discussions)
- 📧 **Email**: arjanchaudharyy@gmail.com
- 🐦 **Twitter**: [@arjanchaudharyy](https://twitter.com/arjanchaudharyy)

---

## ⚠️ Disclaimer

**LEGAL NOTICE:** CTXREC is designed for authorized security testing and educational purposes only.

- ✅ **DO** obtain written permission before scanning
- ✅ **DO** respect scope boundaries and exclusions
- ✅ **DO** follow bug bounty program rules
- ✅ **DO** use responsibly and ethically

- ❌ **DO NOT** scan targets without authorization
- ❌ **DO NOT** use for malicious purposes
- ❌ **DO NOT** ignore rate limits or cause service disruption
- ❌ **DO NOT** violate laws or regulations

**Unauthorized access to computer systems is illegal.** Users are solely responsible for their actions. The developers of CTXREC assume no liability for misuse or damages caused by this tool.

---

## 🌟 Star History

If you find CTXREC useful, please consider giving it a star ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=arjanchaudharyy/GarudRecon&type=Date)](https://star-history.com/#arjanchaudharyy/GarudRecon&Date)

---

<p align="center">
  <b>Made with ❤️ for the Security Community</b><br>
  <sub>CTXREC - Context Reconnaissance Framework</sub>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-cloud-deployment">Cloud Deploy</a> •
  <a href="#-documentation">Docs</a> •
  <a href="#-contributing">Contribute</a>
</p>
