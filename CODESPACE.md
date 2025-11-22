# GitHub Codespaces Deployment Guide

## 🚀 Deploy CTXREC to GitHub Codespaces

This guide will help you run CTXREC (GarudRecon) in a GitHub Codespace - a complete dev environment in the cloud!

---

## 📋 Table of Contents

1. [What is GitHub Codespaces?](#what-is-github-codespaces)
2. [Quick Start](#quick-start)
3. [Configuration Setup](#configuration-setup)
4. [Running CTXREC](#running-ctxrec)
5. [Accessing the Web Interface](#accessing-the-web-interface)
6. [Tool Installation](#tool-installation)
7. [Troubleshooting](#troubleshooting)
8. [Limitations](#limitations)

---

## 🎯 What is GitHub Codespaces?

GitHub Codespaces provides a complete, cloud-based development environment that runs in your browser. Perfect for:

- ✅ Testing without local setup
- ✅ Consistent environment for all users
- ✅ Access from anywhere
- ✅ No need to install tools locally

**Free tier:** 60 hours/month for individual accounts

---

## ⚡ Quick Start

### Step 1: Create Codespace

```bash
# Method 1: From GitHub Repository
1. Go to https://github.com/arjanchaudharyy/GarudRecon
2. Click the green "Code" button
3. Select "Codespaces" tab
4. Click "Create codespace on main" (or your branch)

# Method 2: From GitHub.com
1. Navigate to the repository
2. Press: . (period key)
   OR
   Change URL from github.com to github.dev
```

### Step 2: Wait for Environment Setup

Codespace will automatically:
- ✅ Clone the repository
- ✅ Install dependencies (if .devcontainer configured)
- ✅ Start VS Code in browser

**Time:** 2-5 minutes for initial setup

---

## 🔧 Configuration Setup

### Create DevContainer Configuration

Create `.devcontainer/devcontainer.json` in your repository:

```json
{
  "name": "CTXREC - Bug Bounty Scanner",
  "image": "mcr.microsoft.com/devcontainers/python:3.11-bullseye",
  
  "features": {
    "ghcr.io/devcontainers/features/go:1": {
      "version": "1.23"
    },
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": true,
      "installOhMyZsh": true
    }
  },
  
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "golang.go",
        "foxundermoon.shell-format"
      ],
      "settings": {
        "terminal.integrated.defaultProfile.linux": "bash",
        "python.defaultInterpreterPath": "/usr/local/bin/python"
      }
    }
  },
  
  "postCreateCommand": "pip install -r requirements.txt && chmod +x start_web.sh garudrecon check_tools.sh",
  
  "forwardPorts": [5000],
  "portsAttributes": {
    "5000": {
      "label": "CTXREC Web Interface",
      "onAutoForward": "notify"
    }
  },
  
  "remoteUser": "vscode",
  
  "mounts": [
    "source=${localWorkspaceFolder}/scans,target=/workspace/scans,type=bind,consistency=cached"
  ]
}
```

### Alternative: Minimal Configuration

If you want faster startup without auto-install:

```json
{
  "name": "CTXREC",
  "image": "ubuntu:22.04",
  "forwardPorts": [5000],
  "postCreateCommand": "apt-get update && apt-get install -y python3 python3-pip && pip3 install -r requirements.txt"
}
```

---

## 🚀 Running CTXREC

### Option 1: Auto Install & Run (Recommended)

```bash
# Open terminal in Codespace (Ctrl+`)
# This will install all tools and start the server
sudo ./start_web.sh
```

**What happens:**
1. Checks for missing tools
2. Auto-installs all reconnaissance tools (10-15 min)
3. Sets up Python virtual environment
4. Starts Flask server on port 5000

### Option 2: Quick Start (Without Tools)

```bash
# Just start the web interface (tools won't work until installed)
python3 web_backend.py
```

### Option 3: Manual Tool Installation

```bash
# Install tools separately
sudo ./install_basic_tools.sh

# Then start server
python3 web_backend.py
```

---

## 🌐 Accessing the Web Interface

### Automatic Port Forwarding

GitHub Codespaces automatically forwards port 5000. You'll see:

```
Your application running on port 5000 is available.
```

**Access Methods:**

#### Method 1: Click Notification
- Click the popup notification
- Opens in new browser tab

#### Method 2: Ports Tab
```
1. Click "PORTS" tab in bottom panel
2. Find port 5000
3. Click the globe icon 🌐
4. Opens: https://[unique-name]-5000.preview.app.github.dev
```

#### Method 3: Terminal URL
```bash
# The URL is shown when server starts:
Starting server on http://0.0.0.0:5000

# Codespace will forward to:
https://[your-codespace-name]-5000.app.github.dev
```

### Making Port Public

By default, forwarded ports are private (only you can access).

**To make it public (for team sharing):**
```
1. Go to PORTS tab
2. Right-click port 5000
3. Select "Port Visibility" → "Public"
4. Share the URL with your team
```

⚠️ **Security Warning:** Only make ports public if you trust all users!

---

## 🛠️ Tool Installation

### Pre-installed in Codespace

Codespaces come with:
- ✅ Python 3.x
- ✅ Git
- ✅ curl, wget
- ✅ Build tools (gcc, make)

### Need to Install

CTXREC requires these security tools:

#### System Tools
```bash
sudo apt-get update
sudo apt-get install -y \
  dnsutils \
  nmap \
  git \
  wget \
  curl \
  jq
```

#### Go Tools (10-15 min)
```bash
# Install Go (if not in devcontainer)
wget https://go.dev/dl/go1.23.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.23.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# Install reconnaissance tools
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/tomnomnom/anew@latest

# Add Go bin to PATH
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
```

#### Python Tools
```bash
pip3 install sqlmap
```

### Automated Installation (Easiest)

```bash
# Let start_web.sh handle everything
sudo ./start_web.sh
```

---

## 📊 Codespace Workflow

### Typical Development Session

```bash
# 1. Open Codespace (from GitHub)
https://github.com/[your-username]/GarudRecon

# 2. Terminal opens automatically
# Install tools (first time only)
sudo ./start_web.sh

# 3. Server starts automatically
# Access at: https://[codespace]-5000.app.github.dev

# 4. Make changes to code
# Hot reload: Server restarts automatically

# 5. Test changes
# Run scans, check logs, verify features

# 6. Commit changes
git add .
git commit -m "Enhanced UI features"
git push
```

### Persistent Storage

**Important:** Codespaces have 32GB storage, but data persists only while active.

**To preserve scan results:**
```bash
# Download results before stopping Codespace
# Method 1: Via web interface (Download button)

# Method 2: Git commit
git add scans/
git commit -m "Save scan results"
git push

# Method 3: Download via VS Code
# Right-click scans/ → Download
```

---

## 🔒 Security Considerations

### Running Security Tools in Cloud

**Allowed:**
- ✅ Scanning domains you own
- ✅ Testing with permission
- ✅ Educational purposes on test domains

**Not Allowed:**
- ❌ Unauthorized scanning
- ❌ Port scanning GitHub infrastructure
- ❌ Malicious activity

**GitHub's Terms:**
- Codespaces must comply with Acceptable Use Policy
- Don't use for cryptocurrency mining
- Don't use for excessive resource consumption

### Safe Test Domains

Use these for testing:
```
scanme.nmap.org      (Nmap's official test server)
testphp.vulnweb.com  (Acunetix test site)
example.com          (Basic DNS tests only)
```

---

## 🐛 Troubleshooting

### Issue 1: Codespace Won't Start

**Symptom:** Stuck on "Creating codespace..."

**Solutions:**
```bash
# Try again with different region
1. Cancel current codespace
2. Create new codespace
3. Select different region in settings

# Or use smaller machine type
Settings → Codespaces → Machine type → 2-core (default)
```

### Issue 2: Port 5000 Not Forwarding

**Symptom:** Can't access web interface

**Solutions:**
```bash
# Check if server is running
ps aux | grep web_backend.py

# Check port binding
netstat -tlnp | grep 5000

# Manually forward port
1. Go to PORTS tab
2. Click "Add Port"
3. Enter: 5000
4. Click the globe icon

# Restart server with correct binding
python3 web_backend.py
# Ensure it says: http://0.0.0.0:5000 (not localhost)
```

### Issue 3: Tools Not Installing

**Symptom:** "command not found: httpx"

**Solutions:**
```bash
# Check Go installation
go version

# Check PATH
echo $PATH
# Should include: /home/vscode/go/bin

# Manually add to PATH
export PATH=$PATH:$HOME/go/bin

# Verify installation
which httpx
which subfinder

# Re-run installer
sudo ./start_web.sh
```

### Issue 4: Permission Denied

**Symptom:** "Permission denied" when running scripts

**Solutions:**
```bash
# Make scripts executable
chmod +x start_web.sh
chmod +x garudrecon
chmod +x check_tools.sh
chmod +x cmd/scan_*

# Or run with bash
bash start_web.sh
```

### Issue 5: Out of Storage

**Symptom:** "No space left on device"

**Solutions:**
```bash
# Check disk usage
df -h

# Clean up
rm -rf ~/.cache/*
rm -rf /tmp/*
rm -rf scans/old-scan-*

# Commit important files before cleanup
git add important-scans/
git commit -m "Save scans"
```

### Issue 6: Slow Performance

**Symptom:** Scans taking too long

**Solutions:**
```bash
# Check machine type
# Settings → Codespaces → Machine type
# Upgrade to 4-core or 8-core for faster scans

# Use Light scan instead of Ultra
# Light: 5-10 minutes
# Cool: 20-30 minutes
# Ultra: 1-2 hours

# Close unused tabs/applications
```

---

## 📊 Codespace Machine Types

### Free Tier

**2-core (default)**
- CPU: 2 cores
- RAM: 4GB
- Storage: 32GB
- **Good for:** Light scans, development

### Paid Tiers

**4-core**
- CPU: 4 cores
- RAM: 8GB
- Storage: 32GB
- **Good for:** Cool scans, faster performance

**8-core**
- CPU: 8 cores
- RAM: 16GB
- Storage: 64GB
- **Good for:** Ultra scans, production testing

**Cost:** ~$0.18/hour for 4-core (check GitHub pricing)

---

## 🎯 Best Practices

### 1. Use .gitignore

Prevent committing large scan files:

```bash
# .gitignore
scans/
*.txt
*.json
!results.json
venv/
__pycache__/
*.pyc
```

### 2. Stop Codespace When Done

```bash
# Codespaces charge by active time
# Always stop when finished:
Codespaces → ⋮ → Stop Codespace

# Or set auto-stop timeout:
Settings → Default retention → 30 minutes
```

### 3. Use Prebuilds (Optional)

Speed up startup with prebuilds:

```bash
# .github/workflows/codespaces-prebuild.yml
# Auto-installs tools before you open Codespace
# See GitHub docs for configuration
```

### 4. Save Important Results

```bash
# Before stopping Codespace:
git add scans/important-*
git commit -m "Save critical findings"
git push
```

### 5. Use Environment Variables

```bash
# Create .env for sensitive data
API_KEY=your_api_key
SLACK_WEBHOOK=your_webhook

# Add to .gitignore
echo ".env" >> .gitignore
```

---

## 🔄 Comparison: Local vs Codespace

| Feature | Local | Codespace |
|---------|-------|-----------|
| Setup Time | 30-60 min | 5-10 min |
| Tool Installation | Manual | Automated |
| Performance | Depends on PC | Consistent |
| Access | One device | Any browser |
| Storage | Unlimited | 32GB |
| Cost | Free | $0-18/month |
| Port Forwarding | Manual | Automatic |
| Team Sharing | Hard | Easy (public port) |

---

## 🚀 Quick Reference Commands

### Starting CTXREC
```bash
# Full auto-install
sudo ./start_web.sh

# Quick start (no tools)
python3 web_backend.py

# Background mode
nohup python3 web_backend.py > server.log 2>&1 &
```

### Checking Status
```bash
# Check if server is running
ps aux | grep web_backend

# Check installed tools
./check_tools.sh

# Check port forwarding
gh codespace ports

# Check disk space
df -h
```

### Managing Codespace
```bash
# List codespaces
gh codespace list

# Stop codespace
gh codespace stop

# Delete codespace
gh codespace delete

# SSH into codespace
gh codespace ssh
```

---

## 📚 Additional Resources

### GitHub Documentation
- [Codespaces Overview](https://docs.github.com/en/codespaces)
- [Devcontainer Configuration](https://containers.dev/)
- [Port Forwarding](https://docs.github.com/en/codespaces/developing-in-codespaces/forwarding-ports-in-your-codespace)

### CTXREC Documentation
- `WEB_INTERFACE_ENHANCED.md` - Complete UI guide
- `TESTING_GUIDE.md` - Testing instructions
- `TOOL_INSTALLATION_GUIDE.md` - Manual tool setup
- `README.md` - Full project documentation

---

## 🎉 You're Ready!

**To deploy right now:**

```bash
1. Go to: https://github.com/arjanchaudharyy/GarudRecon
2. Click: Code → Codespaces → Create codespace
3. Wait: 2-5 minutes for setup
4. Run: sudo ./start_web.sh
5. Access: Click the port 5000 notification
6. Scan: Enter a domain and start scanning!
```

**Total time:** 15-20 minutes (including tool installation)

---

## 🤝 Contributing

Found an issue with Codespace deployment?

```bash
# Open an issue
https://github.com/arjanchaudharyy/GarudRecon/issues

# Or submit a PR
git checkout -b fix/codespace-issue
git commit -m "Fix: Codespace port forwarding"
git push origin fix/codespace-issue
```

---

## ⚠️ Disclaimer

**Legal Notice:**
- Only scan domains you own or have explicit permission to test
- Codespaces are subject to GitHub's Acceptable Use Policy
- Unauthorized scanning is illegal and violates GitHub's terms
- This tool is for educational and authorized security testing only

---

## 📞 Support

**Having trouble?**

1. Check [Troubleshooting](#troubleshooting) section
2. Review GitHub Codespaces logs
3. Open an issue on GitHub
4. Read `TESTING_GUIDE.md` for detailed tests

---

**Created by:** [arjanchaudharyy](https://github.com/arjanchaudharyy)  
**Repository:** https://github.com/arjanchaudharyy/GarudRecon  
**License:** MIT

---

**Happy scanning in the cloud!** ☁️🔍
