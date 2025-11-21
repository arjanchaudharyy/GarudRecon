# CTXREC - Rebranding & Auto-Installer Complete

## 🎉 Major Updates

### 1. **Automatic Tool Installation** ✨

CTXREC now automatically downloads and installs all required reconnaissance tools on startup!

#### How it Works:

When you start the web interface with `./start_web.sh` or `python3 web_backend.py`:

1. **Auto-Detection**: Checks for missing tools (dig, nmap, httpx, subfinder, nuclei, etc.)
2. **Auto-Download**: Downloads and installs missing tools using curl/wget
3. **Auto-Configuration**: Sets up Go environment and PATH automatically
4. **Ready to Scan**: All tools installed in 5-15 minutes!

#### New Auto-Installer Script:

```bash
./auto_install_tools.sh
```

**Features:**
- ✅ Installs system packages (dig, nmap, curl, wget, git, jq)
- ✅ Downloads and installs Go language
- ✅ Installs 10+ Go-based recon tools
- ✅ Installs Python tools (sqlmap)
- ✅ Configures PATH automatically
- ✅ Works on Linux, macOS, and WSL
- ✅ Detailed installation log at `/tmp/ctxrec_install.log`

### 2. **Complete Rebranding: GarudRecon → CTXREC** 🔄

All references updated throughout the project:

#### Files Updated:

**Core Files:**
- ✅ `web_backend.py` - Main server with auto-installer
- ✅ `web/index.html` - Web interface title and header
- ✅ `web/style.css` - Added author credit styling
- ✅ `start_web.sh` - Launcher script
- ✅ `README.md` - Main documentation

**Scan Scripts:**
- ✅ `cmd/scan_light` - Light scan mode
- ✅ `cmd/scan_cool` - Cool scan mode
- ✅ `cmd/scan_ultra` - Ultra scan mode

**Tool Scripts:**
- ✅ `check_tools.sh` - Tool verification
- ✅ `install_basic_tools.sh` - Manual installer
- ✅ `startup_check.sh` - Startup verification
- ✅ `demo_workflow.sh` - Demo script
- ✅ `auto_install_tools.sh` - NEW auto-installer

**Attribution:**
- ✅ All files now credit: **arjanchaudharyy**
- ✅ GitHub link: https://github.com/arjanchaudharyy

### 3. **Enhanced Web Interface** 🌐

**New Header:**
```
🛡️ CTXREC
Advanced Reconnaissance & Vulnerability Scanner
Created by: arjanchaudharyy
```

**On Startup:**
```
============================================================
CTXREC - Checking tool availability...
============================================================

⚠️  Missing tools detected: httpx, subfinder, nuclei
🔧 Starting automatic tool installation...
This may take 5-15 minutes depending on your system.

[10:30:15] Installing system tools...
[10:30:45] ✓ System tools installed
[10:30:46] Installing Go language...
[10:32:15] ✓ Go installed successfully
[10:32:16] Installing Go-based reconnaissance tools...
[10:32:17]   Installing httpx...
[10:32:45]     ✓ httpx installed
[10:32:46]   Installing subfinder...
[10:33:12]     ✓ subfinder installed
...

✅ Tool installation completed successfully!

============================================================
CTXREC Web Interface
Created by: arjanchaudharyy
============================================================
```

## 📦 What's Installed Automatically

### System Tools (via apt/yum/brew):
- `dig` - DNS queries
- `nmap` - Port scanning
- `curl` - HTTP requests
- `wget` - Downloads
- `git` - Version control
- `jq` - JSON processing
- `python3` - Python runtime
- `python3-pip` - Python packages

### Go Programming Language:
- Go 1.21.5 (latest stable)
- Auto-configured GOPATH
- Added to system PATH

### Go-Based Recon Tools:
- `httpx` - HTTP probing
- `subfinder` - Subdomain enumeration
- `dnsx` - DNS resolution
- `naabu` - Port scanning
- `nuclei` - Vulnerability scanning
- `katana` - Web crawling
- `waybackurls` - Historical URLs
- `gau` - URL gathering
- `assetfinder` - Asset discovery
- `dalfox` - XSS detection

### Python Tools:
- `Flask` - Web framework
- `flask-cors` - CORS support
- `sqlmap` - SQLi detection

## 🚀 Quick Start

### Completely Automated (Recommended):

```bash
# 1. Clone the repository
git clone https://github.com/arjanchaudharyy/GarudRecon
cd GarudRecon

# 2. Start the web interface
./start_web.sh

# That's it! Tools will be installed automatically
# Access: http://localhost:5000
```

### Manual Installation (Optional):

```bash
# Check what's installed
./check_tools.sh

# Install manually if preferred
sudo ./install_basic_tools.sh

# Or use auto-installer
./auto_install_tools.sh

# Start server
./start_web.sh
```

## 📊 Before vs After

### BEFORE (Old GarudRecon):
```
❌ Manual tool installation required
❌ Complex setup process
❌ No automatic detection
❌ Users see 0 results
❌ Confusing error messages
```

### AFTER (New CTXREC):
```
✅ Automatic tool installation
✅ One-command setup
✅ Auto-detects missing tools
✅ Real results immediately
✅ Clear progress indicators
✅ Detailed logging
```

## 🎯 Key Features

### 1. Zero Configuration
- No manual setup needed
- Automatic dependency resolution
- Smart PATH configuration

### 2. Cross-Platform
- Linux (Ubuntu, Debian, CentOS, etc.)
- macOS (via Homebrew)
- Windows WSL

### 3. Intelligent Installation
- Only installs missing tools
- Skips already installed tools
- Handles errors gracefully
- Detailed progress logging

### 4. Production Ready
- 15-minute timeout for installations
- Error recovery
- Fallback to manual installation
- Comprehensive logging

## 🛠️ Technical Details

### Auto-Installer Logic:

```python
def auto_install_tools():
    # 1. Check for missing tools
    missing_tools = check_missing_tools()
    
    if missing_tools:
        # 2. Run installer script
        run_installer_script()
        
        # 3. Update PATH
        update_environment()
        
        # 4. Verify installation
        verify_tools()
```

### Installation Flow:

```
Start Web Interface
       ↓
Check Tools (dig, nmap, httpx, etc.)
       ↓
Missing Tools? → Yes → Run Auto-Installer
       ↓                      ↓
       No                Install System Packages
       ↓                      ↓
Start Server ←←←←←←←← Install Go
                             ↓
                      Install Go Tools
                             ↓
                      Install Python Tools
                             ↓
                      Update PATH
                             ↓
                      Done! Start Server
```

### Installation Locations:

```
System Tools:    /usr/bin/
Go Binary:       /usr/local/go/bin/go
Go Tools:        ~/go/bin/
Python Tools:    ~/.local/bin/
Config:          ~/.bashrc or ~/.zshrc
Logs:            /tmp/ctxrec_install.log
```

## 📝 Attribution

**Created by:** [arjanchaudharyy](https://github.com/arjanchaudharyy)

All credits, headers, and references now point to arjanchaudharyy.

## 🔍 Testing

Test the auto-installer:

```bash
# Check current status
./check_tools.sh

# Test auto-install
./auto_install_tools.sh

# Verify installation
./check_tools.sh

# Test with real scan
./cmd/scan_light -d example.com -o test
cat test/results.json
```

## 📄 Files Modified

**New Files (1):**
- `auto_install_tools.sh` - Automatic tool installer

**Modified Files (10):**
- `web_backend.py` - Added auto-installer integration
- `web/index.html` - Rebranded to CTXREC
- `web/style.css` - Added author styling
- `start_web.sh` - Updated branding
- `README.md` - Updated documentation
- `cmd/scan_light` - Updated headers
- `cmd/scan_cool` - Updated headers
- `cmd/scan_ultra` - Updated headers
- `check_tools.sh` - Updated branding
- `install_basic_tools.sh` - Updated branding
- `startup_check.sh` - Updated branding
- `demo_workflow.sh` - Updated branding

## 🎉 Summary

CTXREC is now:
1. ✅ **Fully automated** - Installs tools on first run
2. ✅ **Properly branded** - CTXREC everywhere
3. ✅ **Properly credited** - All credits to arjanchaudharyy
4. ✅ **User-friendly** - One command to start
5. ✅ **Production-ready** - Robust error handling

**Start scanning in 3 steps:**
```bash
git clone https://github.com/arjanchaudharyy/GarudRecon
cd GarudRecon
./start_web.sh
```

That's it! 🚀
