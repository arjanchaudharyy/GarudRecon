# Windows Setup Guide for GarudRecon

## Issues Fixed

### 1. Unicode Encoding Error
**Error**: `UnicodeEncodeError: 'charmap' codec can't encode characters`

**Solution**: The web backend now automatically detects Windows and sets UTF-8 encoding for console output. Emoji characters have been replaced with ASCII-safe alternatives `[!]`, `[+]`, `[*]`, `[i]`.

### 2. WinError 193 - Invalid Win32 Application
**Error**: `[WinError 193] %1 is not a valid Win32 application`

**Cause**: GarudRecon scan scripts are bash scripts that cannot run natively on Windows.

**Solutions** (choose one):

## Option 1: Use WSL (Recommended for Windows)

### Install WSL
```powershell
# Open PowerShell as Administrator
wsl --install
```

After installation and restart:
```powershell
# Verify WSL is working
wsl --status

# Install Ubuntu (if not already installed)
wsl --install -d Ubuntu
```

### Setup GarudRecon in WSL
```bash
# Inside WSL Ubuntu terminal
cd /mnt/c/Users/YourUsername/garudrecon

# Install tools
sudo ./install_basic_tools.sh

# Run web interface
python3 web_backend.py
```

The web backend will automatically detect WSL and run scans through it.

### Run from Windows (with WSL backend)
Once WSL is installed and GarudRecon tools are set up in WSL:

```powershell
# From Windows PowerShell/Command Prompt
python3 web_backend.py
```

The backend will:
- Detect WSL is available
- Automatically run scan scripts through WSL
- Display: `[+] WSL detected - scans will run through WSL`

## Option 2: Use Docker

### Install Docker Desktop
Download from: https://www.docker.com/products/docker-desktop

### Run GarudRecon in Docker
```powershell
# Build the Docker image
docker build -t garudrecon .

# Run the container
docker run -p 5000:5000 -v ${PWD}/scans:/app/scans garudrecon

# Access at: http://localhost:5000
```

All tools are pre-installed in the Docker image.

## Option 3: Deploy to Cloud (No Local Setup)

Deploy to Railway, Heroku, or any cloud platform that supports Docker:

### Railway (Easiest)
1. Push code to GitHub
2. Go to https://railway.app
3. Click "New Project" → "Deploy from GitHub"
4. Select your repository
5. Railway will automatically detect Dockerfile and deploy

Tools are pre-installed in the Docker build.

See `RAILWAY_DEPLOYMENT_GUIDE.md` for detailed instructions.

## Platform Detection Status

When you run `python3 web_backend.py` on Windows:

### With WSL Installed
```
============================================================
CTXREC - Checking tool availability...
============================================================

[!] WARNING: Running on Windows
[+] WSL detected - scans will run through WSL

[!] Missing tools: dig, nmap, curl, httpx, subfinder, nuclei

[*] To install missing tools, run:
  sudo ./install_basic_tools.sh
```

### Without WSL
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

### WSL Not Detected (but installed)
Restart your computer after WSL installation.

### Scans Still Fail with WSL
Make sure tools are installed inside WSL:
```bash
wsl
cd /mnt/c/Users/YourUsername/garudrecon
sudo ./install_basic_tools.sh
```

### Path Issues with WSL
The backend automatically converts Windows paths to WSL paths:
- Windows: `C:\Users\AARJAN\garudrecon\scans\123-456`
- WSL: `/mnt/c/Users/AARJAN/garudrecon/scans/123-456`

### Console Encoding Still Shows Errors
Update Python to 3.7+ (required for `sys.stdout.reconfigure()`):
```powershell
python --version  # Check version
```

If still having issues, the backend now uses ASCII fallback characters.

## Verification

### Test WSL Detection
```python
import subprocess
try:
    subprocess.run(['wsl', '--status'], capture_output=True, timeout=2)
    print("WSL is available!")
except:
    print("WSL not found")
```

### Test Scan Execution
```powershell
# Start the server
python3 web_backend.py

# Open browser: http://localhost:5000
# Try a scan - it should show WSL status in logs
```

## Summary

| Method | Setup Time | Scan Performance | Best For |
|--------|------------|------------------|----------|
| **WSL** | 10 min | Fast (native) | Windows developers |
| **Docker** | 5 min | Good (containerized) | Quick testing |
| **Cloud** | 15 min | Excellent (dedicated) | Production use |

## References

- WSL Installation: https://docs.microsoft.com/windows/wsl/install
- Docker Desktop: https://docs.docker.com/desktop/windows/install/
- Railway Deployment: https://railway.app/docs
- GarudRecon GitHub: https://github.com/arjanchaudharyy/GarudRecon
