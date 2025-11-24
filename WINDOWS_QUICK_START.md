# Windows Quick Start Guide

## TL;DR - Get GarudRecon Running on Windows

### Option 1: WSL (5-10 minutes) ⭐ RECOMMENDED

```powershell
# 1. Install WSL (PowerShell as Admin)
wsl --install

# 2. Restart computer

# 3. Open WSL Ubuntu terminal
wsl

# 4. Navigate to GarudRecon
cd /mnt/c/Users/YourUsername/garudrecon

# 5. Install tools
sudo ./install_basic_tools.sh

# 6. Exit WSL and run from Windows
exit
python3 web_backend.py

# 7. Open browser
http://localhost:5000
```

### Option 2: Docker (2 minutes)

```powershell
# 1. Install Docker Desktop
# Download from: https://www.docker.com/products/docker-desktop

# 2. Build and run
docker build -t garudrecon .
docker run -p 5000:5000 garudrecon

# 3. Open browser
http://localhost:5000
```

### Option 3: Cloud (0 minutes local setup)

```
1. Push to GitHub
2. Go to https://railway.app
3. New Project → Deploy from GitHub
4. Select your repo
5. Done! Railway gives you a URL
```

## What Got Fixed?

### Before (Broken ❌)
```
Exception in thread Thread-1 (auto_install_tools):
...
UnicodeEncodeError: 'charmap' codec can't encode characters
```

```
ERROR: [WinError 193] %1 is not a valid Win32 application
```

### After (Working ✅)

**With WSL:**
```
============================================================
CTXREC - Checking tool availability...
============================================================

[!] WARNING: Running on Windows
[+] WSL detected - scans will run through WSL

[*] To install missing tools, run:
  sudo ./install_basic_tools.sh
```

**Without WSL:**
```
============================================================
CTXREC - Checking tool availability...
============================================================

[!] WARNING: Running on Windows
[!] WSL not detected - GarudRecon requires Linux environment
[!] Please install WSL: https://docs.microsoft.com/windows/wsl/install
[!] Or use Docker: docker run -p 5000:5000 garudrecon

[i] Web interface will start, but scans will fail without WSL/Docker
```

## Troubleshooting

### "WSL not detected" but I installed it
**Solution:** Restart your computer after WSL installation

### "bash: command not found" errors in scans
**Solution:** Tools must be installed inside WSL:
```bash
wsl
cd /mnt/c/Users/YourUsername/garudrecon
sudo ./install_basic_tools.sh
```

### Scans show 0 results
**Cause:** Tools not installed in WSL
**Solution:** See above

### Still getting Unicode errors
**Solution:** Update Python to 3.7+:
```powershell
python --version  # Should be 3.7 or higher
```

## Testing Your Setup

```powershell
# Test platform detection
python3 test_windows_fix.py

# Start server
python3 web_backend.py

# Should see:
# [!] WARNING: Running on Windows
# [+] WSL detected - scans will run through WSL
```

## Need More Help?

📖 Full Guide: `WINDOWS_SETUP.md`
📖 Fix Details: `WINDOWS_FIX_SUMMARY.md`
🐛 Issues: https://github.com/arjanchaudharyy/GarudRecon/issues

## Comparison

| Method | Setup Time | Best For |
|--------|------------|----------|
| **WSL** | 10 min | Development |
| **Docker** | 5 min | Testing |
| **Cloud** | 15 min | Production |

Choose what works best for you! 🚀
