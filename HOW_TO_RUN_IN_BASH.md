# How to Run GarudRecon in Bash

Since **GarudRecon** relies on Bash scripts and Linux-native security tools, you need a Bash environment to run it.

## 1. If you are on Linux or macOS

You are already in a Bash environment!

1. Open your terminal.
2. Navigate to the project directory:
   ```bash
   cd garudrecon
   ```
3. Run the web interface:
   ```bash
   sudo ./start_web.sh
   ```
   *Note: `sudo` is recommended to allow the script to auto-install missing tools.*

## 2. If you are on Windows

Windows does not natively support Bash scripts. You have two options:

### Option A: Use WSL (Windows Subsystem for Linux) - Recommended

WSL allows you to run a real Ubuntu/Linux environment directly on Windows.

1. **Install WSL**:
   Open PowerShell as Administrator and run:
   ```powershell
   wsl --install
   ```
   *Restart your computer if prompted.*

2. **Open WSL**:
   Open your Start Menu, type `Ubuntu` or `WSL`, and press Enter. This opens a Bash terminal.

3. **Navigate to your project**:
   Your Windows files are mounted under `/mnt/c/`.
   ```bash
   cd /mnt/c/Users/YourName/path/to/garudrecon
   ```

4. **Run GarudRecon**:
   Now you are in Bash, so you can run the scripts normally:
   ```bash
   sudo ./start_web.sh
   ```
   
   Or manually:
   ```bash
   python3 web_backend.py
   ```
   *The backend will detect it's running in WSL and execute scans correctly.*

### Option B: Use Docker

Docker runs the tool in an isolated Linux container.

1. Install Docker Desktop.
2. Run the container:
   ```bash
   docker build -t garudrecon .
   docker run -p 5000:5000 garudrecon
   ```
3. Open `http://localhost:5000` in your browser.

## 3. How to Run Scans Manually (CLI Mode)

If you don't want to use the web interface, you can run scans directly from the terminal (Bash/WSL only).

1. Make sure you are in the `garudrecon` directory.
2. Run the main script:
   ```bash
   ./garudrecon --help
   ```

3. Start a scan:
   ```bash
   ./garudrecon smallscope -d example.com
   ```

## Troubleshooting

### "GarudRecon requires Linux environment" Error on Windows

If you see this error, it means you ran `python3 web_backend.py` from **Windows PowerShell** or **Command Prompt**, but WSL is not installed or not detected.

**Fix**:
1. Install WSL (`wsl --install`).
2. Run the command again. The Python script will auto-detect WSL and use it.

### "wsl: command not found"

If you are inside WSL and see this, something is wrong with your WSL installation. You should be able to run standard Linux commands like `ls`, `grep`, etc.

### "permission denied"

Make sure scripts are executable:
```bash
chmod +x garudrecon start_web.sh install_basic_tools.sh cmd/*
```
