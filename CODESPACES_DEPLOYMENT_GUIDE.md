# GitHub Codespaces Deployment Guide

Complete guide to deploy and run GarudRecon in GitHub Codespaces.

---

## 📋 Table of Contents

1. [What is GitHub Codespaces?](#what-is-github-codespaces)
2. [Why Use Codespaces for GarudRecon?](#why-use-codespaces-for-garudrecon)
3. [Prerequisites](#prerequisites)
4. [Step-by-Step Setup](#step-by-step-setup)
5. [Running GarudRecon](#running-garudrecon)
6. [Accessing the Web Interface](#accessing-the-web-interface)
7. [Configuration](#configuration)
8. [Troubleshooting](#troubleshooting)
9. [Tips & Best Practices](#tips--best-practices)

---

## 🚀 What is GitHub Codespaces?

GitHub Codespaces is a cloud-based development environment that runs directly in your browser. It provides:
- **Pre-configured Ubuntu environment** (perfect for GarudRecon)
- **VS Code in the browser** with full terminal access
- **Free tier**: 60 hours/month for personal accounts
- **Port forwarding** for web interfaces
- **Persistent storage** for your scans

---

## 🎯 Why Use Codespaces for GarudRecon?

✅ **No local setup required** - Everything runs in the cloud  
✅ **Consistent environment** - Ubuntu with all dependencies  
✅ **Easy access** - Access from anywhere via browser  
✅ **Free to start** - 60 hours/month on free tier  
✅ **Powerful machines** - 2-8 cores, 4-16 GB RAM  
✅ **Perfect for testing** - Try GarudRecon without installing locally  

---

## 📦 Prerequisites

1. **GitHub Account** (Free tier includes 60 hours/month of Codespaces)
2. **Browser** (Chrome, Firefox, Edge, Safari)
3. **Internet connection**

That's it! No local installation needed.

---

## 🛠️ Step-by-Step Setup

### Step 1: Fork the Repository (Optional)

If you want to save your changes:

1. Go to https://github.com/arjanchaudharyy/GarudRecon
2. Click **"Fork"** button (top right)
3. Wait for fork to complete

**OR** use the original repository directly (no persistence of changes).

---

### Step 2: Create a Codespace

#### Option A: From GitHub.com

1. Go to the repository: https://github.com/arjanchaudharyy/GarudRecon
2. Click the **green "Code"** button
3. Select **"Codespaces"** tab
4. Click **"Create codespace on main"**

![Create Codespace](https://docs.github.com/assets/cb-138303/mw-1440/images/help/codespaces/new-codespace-button.webp)

#### Option B: Direct Link

Use this link to create a codespace instantly:
```
https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=YOUR_REPO_ID
```

#### Option C: From VS Code Desktop

1. Install **"GitHub Codespaces"** extension
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
3. Type **"Codespaces: Create New Codespace"**
4. Select the GarudRecon repository

---

### Step 3: Wait for Environment Setup

Codespaces will automatically:
- ✅ Create an Ubuntu VM
- ✅ Install basic dependencies
- ✅ Clone the repository
- ✅ Open VS Code in browser

**Wait time**: 30-60 seconds

---

### Step 4: Open Terminal

In VS Code (browser):
1. Click **"Terminal"** menu → **"New Terminal"**
2. OR press `` Ctrl+` `` (backtick)

You should see a bash prompt:
```bash
@username ➜ /workspaces/GarudRecon (main) $
```

---

### Step 5: Install Tools (CRITICAL)

GarudRecon requires external security tools. Choose one method:

#### Method A: Auto-Install (RECOMMENDED)

Run the automated installer:
```bash
sudo ./start_web.sh
```

This will:
- Check for Python 3
- **Auto-install ALL required tools** (10-15 minutes)
- Display installation summary
- Setup Python virtual environment
- Start the web server automatically

**Wait time**: 10-15 minutes for tool installation

#### Method B: Quick Install (Basic Tools Only)

For faster setup with essential tools only:
```bash
sudo ./install_basic_tools.sh
```

Then start the server:
```bash
./garudrecon web
```

#### Method C: Manual Install (Full Control)

Install all tools manually:
```bash
./garudrecon install -f ALL
```

**Note**: You'll be prompted for sudo password during installation.

---

### Step 6: Verify Installation

Check which tools are installed:
```bash
./check_tools.sh
```

Expected output:
```
✓ dig - installed
✓ nmap - installed
✓ httpx - installed
✓ subfinder - installed
...
```

---

## 🌐 Running GarudRecon

### Start the Web Interface

If not already running from `start_web.sh`:

```bash
./garudrecon web
```

You should see:
```
 * Running on http://0.0.0.0:5000
 * Serving Flask app 'web_backend'
 * Debug mode: off
```

**Keep this terminal open** - closing it will stop the server.

---

## 🔗 Accessing the Web Interface

### Automatic Port Forwarding

GitHub Codespaces **automatically forwards port 5000** and gives you a URL.

#### Find Your URL:

1. **Look at the terminal** - you'll see a popup:
   ```
   Your application running on port 5000 is available.
   ```
   Click **"Open in Browser"**

2. **OR check the Ports tab**:
   - Click **"PORTS"** tab (bottom panel, next to Terminal)
   - Find port **5000**
   - Click the **globe icon** or **copy the forwarded URL**

3. **OR use the Command Palette**:
   - Press `Ctrl+Shift+P`
   - Type **"Ports: Focus on Ports View"**

Your URL will look like:
```
https://username-garudrecon-abc123xyz.github.dev
```

### Make Port Public (If Needed)

By default, ports are **private** (only you can access).

To make it public:
1. Right-click on port **5000** in the Ports tab
2. Select **"Port Visibility"** → **"Public"**

Now anyone with the link can access your instance.

---

## ⚙️ Configuration

### Increase Machine Size (Optional)

For faster scans, upgrade your Codespace:

1. Go to https://github.com/codespaces
2. Click **⋮** (three dots) on your codespace
3. Select **"Change machine type"**
4. Choose:
   - **4-core, 8GB RAM** (for Cool/Ultra scans)
   - **8-core, 16GB RAM** (for multiple concurrent scans)

**Note**: Larger machines consume your free hours faster.

### Set Environment Variables (Optional)

Create a `.env` file for custom configuration:
```bash
nano .env
```

Add:
```bash
PORT=5000
LOG_LEVEL=INFO
MAX_SCAN_DURATION=7200
```

### Increase Timeout (Optional)

For long-running Ultra scans, increase timeout:
```bash
nano web_backend.py
```

Find:
```python
DEFAULT_TIMEOUT = 3600  # 1 hour
```

Change to:
```python
DEFAULT_TIMEOUT = 7200  # 2 hours
```

---

## 🐛 Troubleshooting

### Issue 1: Port 5000 Not Forwarding

**Symptoms**: Server starts but URL not accessible

**Solution**:
1. Check if port is forwarded in **Ports** tab
2. Manually add port:
   - Click **"Forward a Port"** button
   - Enter **5000**
   - Click **"Add"**

### Issue 2: Tools Not Installed

**Symptoms**: Scans show 0 results (DNS: 0, Ports: 0, URLs: 0)

**Solution**:
```bash
# Check which tools are missing
./check_tools.sh

# Install missing tools
sudo ./start_web.sh
```

### Issue 3: Permission Denied

**Symptoms**: `bash: ./garudrecon: Permission denied`

**Solution**:
```bash
# Make scripts executable
chmod +x garudrecon
chmod +x start_web.sh
chmod +x check_tools.sh
chmod +x cmd/*
```

### Issue 4: Python Virtual Environment Issues

**Symptoms**: `ModuleNotFoundError: No module named 'flask'`

**Solution**:
```bash
# Install Python dependencies
pip3 install -r requirements.txt

# OR recreate virtual environment
rm -rf venv/
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Issue 5: Codespace Timeout

**Symptoms**: Codespace stops after 30 minutes of inactivity

**Solution**:
- Free tier: **30 minutes** idle timeout
- Keep browser tab open during scans
- OR use CLI to prevent sleep:
  ```bash
  # Run scan in background
  nohup ./garudrecon web > server.log 2>&1 &
  ```

### Issue 6: Out of Storage

**Symptoms**: `No space left on device`

**Solution**:
```bash
# Check disk usage
df -h

# Clean old scans
rm -rf scans/*

# Clean Docker cache (if applicable)
docker system prune -a
```

### Issue 7: Server Crashes During Scan

**Symptoms**: Server stops responding during Ultra scan

**Solution**:
```bash
# Increase memory limit (requires restart)
# Go to GitHub Codespaces settings
# OR run scans sequentially:
# 1. Run one scan at a time
# 2. Use Light/Cool instead of Ultra
# 3. Upgrade machine type (4-core minimum)
```

---

## 💡 Tips & Best Practices

### 1. Save Your Scans

Scan results are stored in `/workspaces/GarudRecon/scans/`

**To download scans**:
```bash
# Zip your scans
tar -czf my-scans.tar.gz scans/

# Download via VS Code:
# Right-click on my-scans.tar.gz → Download
```

### 2. Extend Codespace Timeout

Free tier has 30-minute idle timeout. To extend:
1. Go to https://github.com/settings/codespaces
2. Set **"Default idle timeout"** to maximum (4 hours)

### 3. Use Screen/Tmux for Long Scans

For Ultra scans that take 1-2 hours:
```bash
# Install screen
sudo apt-get update
sudo apt-get install screen

# Start screen session
screen -S garudrecon

# Run server
./garudrecon web

# Detach: Press Ctrl+A, then D
# Reattach: screen -r garudrecon
```

### 4. Monitor Resource Usage

Check CPU/memory during scans:
```bash
# Real-time monitoring
htop

# Install if not available
sudo apt-get install htop
```

### 5. Use .codespaces Directory

Save custom configurations:
```bash
# Create persistent settings
mkdir -p .codespaces
echo "export PATH=$PATH:/usr/local/bin" >> .codespaces/.bashrc
```

### 6. Run in Background

For persistent operation:
```bash
# Start server in background
nohup ./garudrecon web > garudrecon.log 2>&1 &

# Check logs
tail -f garudrecon.log

# Stop server
pkill -f web_backend.py
```

### 7. Share Your Codespace

**Public URL**: Make port 5000 public (see Configuration)  
**Collaborative editing**: Invite teammates via Share button  

### 8. Cost Management

Free tier limits:
- **60 hours/month** for 2-core machines
- **30 hours/month** for 4-core machines
- **15 hours/month** for 8-core machines

**Tips to save hours**:
- ✅ Stop codespace when not in use
- ✅ Use 2-core for Light scans
- ✅ Delete unused codespaces
- ✅ Set auto-stop timeout (30 minutes)

---

## 🚀 Quick Start Checklist

Use this checklist for first-time setup:

- [ ] Create GitHub account (if needed)
- [ ] Fork repository (optional)
- [ ] Create codespace from repository
- [ ] Wait for environment setup (30-60 seconds)
- [ ] Open terminal in VS Code
- [ ] Run `sudo ./start_web.sh` (10-15 minutes)
- [ ] Wait for tool installation to complete
- [ ] Find forwarded URL in Ports tab
- [ ] Open URL in browser
- [ ] Run test scan (Light mode on example.com)
- [ ] Verify results appear
- [ ] Bookmark your codespace URL

---

## 📊 Expected Timeline

| Task | Time |
|------|------|
| Create Codespace | 30-60 seconds |
| Tool Installation | 10-15 minutes |
| Server Startup | 5 seconds |
| Light Scan | 5-10 minutes |
| Cool Scan | 20-30 minutes |
| Ultra Scan | 1-2 hours |

---

## 🔐 Security Considerations

1. **Private Ports**: Keep port visibility private unless sharing
2. **Scan Responsibly**: Only scan domains you own or have permission to test
3. **API Keys**: Don't commit API keys (use .env file)
4. **Delete Codespaces**: Remove when done to prevent unauthorized access
5. **Limit Scope**: Use Light scans for public instances

---

## 📚 Additional Resources

- **GitHub Codespaces Docs**: https://docs.github.com/en/codespaces
- **GarudRecon README**: [README.md](README.md)
- **Tool Installation**: [TOOL_INSTALLATION_GUIDE.md](TOOL_INSTALLATION_GUIDE.md)
- **Web Interface**: [WEB_INTERFACE_ENHANCED.md](WEB_INTERFACE_ENHANCED.md)
- **Troubleshooting**: [BUGFIX_SUMMARY.md](BUGFIX_SUMMARY.md)

---

## 🎉 You're Ready!

Your GarudRecon instance is now running in GitHub Codespaces!

Access it at: `https://your-codespace-url.github.dev`

**Next Steps**:
1. Run a test scan on `example.com`
2. Explore the web interface
3. Check scan results and logs
4. Download results via JSON/files
5. Try different scan modes

**Need Help?**
- Check [Troubleshooting](#troubleshooting) section above
- Review [WEB_INTERFACE_ENHANCED.md](WEB_INTERFACE_ENHANCED.md)
- Open an issue on GitHub

---

## 📝 Example Workflow

Complete example from start to finish:

```bash
# 1. Create codespace (via GitHub.com)
# 2. Open terminal

# 3. Install tools
sudo ./start_web.sh

# 4. Wait for installation (10-15 minutes)
# Watch for "Installation Summary" message

# 5. Find your URL (Ports tab → port 5000)
# Example: https://username-garudrecon-abc123xyz.github.dev

# 6. Open URL in browser

# 7. Run test scan:
#    - Domain: example.com
#    - Type: Light
#    - Click "Start Scan"

# 8. Watch real-time logs (color-coded)

# 9. View results:
#    - Summary cards (DNS, Ports, URLs, etc.)
#    - Click files to view/download
#    - Download full JSON

# 10. Run more scans!
```

---

## ⚠️ Common Mistakes to Avoid

1. ❌ **Closing terminal while scan is running** → Scan will stop
2. ❌ **Not installing tools** → 0 results
3. ❌ **Using Ultra scan on 2-core** → Very slow
4. ❌ **Forgetting to make port public** → Can't share URL
5. ❌ **Running multiple Ultra scans** → Out of memory
6. ❌ **Not saving scans before deleting codespace** → Data loss

---

## 🎯 When to Use Codespaces vs Railway

| Feature | Codespaces | Railway |
|---------|------------|---------|
| **Setup Time** | 15 minutes | 3 minutes |
| **Free Tier** | 60 hours/month | 500 hours/month |
| **Persistence** | Manual download | Automatic |
| **Access** | Private by default | Public URL |
| **Best For** | Development, Testing | Production, Sharing |
| **Tool Installation** | Manual (15 min) | Pre-installed |

**Recommendation**:
- **Use Codespaces** for: Testing, development, learning
- **Use Railway** for: Production, public access, sharing with team

---

## 🔄 Stopping and Restarting

### Stop Server (Keep Codespace Running)
```bash
# Press Ctrl+C in terminal
^C

# OR if running in background
pkill -f web_backend.py
```

### Stop Codespace (Saves Resources)
1. Go to https://github.com/codespaces
2. Click **⋮** on your codespace
3. Select **"Stop codespace"**

### Restart Server
```bash
# If tools already installed
./garudrecon web

# If need to reinstall tools
sudo ./start_web.sh
```

### Delete Codespace (When Done)
1. Go to https://github.com/codespaces
2. Click **⋮** on your codespace
3. Select **"Delete"**

**⚠️ Warning**: This deletes all data (including scans) permanently!

---

## 📞 Support

Having issues? Try these:

1. **Check tool installation**: `./check_tools.sh`
2. **Review logs**: `tail -f garudrecon.log`
3. **Restart codespace**: Stop → Start
4. **Recreate codespace**: Delete → Create new
5. **Check GitHub Status**: https://www.githubstatus.com/

Still stuck? Open an issue: https://github.com/arjanchaudharyy/GarudRecon/issues

---

**Happy Scanning! 🔍🛡️**
