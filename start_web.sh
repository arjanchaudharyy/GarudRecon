#!/bin/bash

# CTXREC Web Interface Launcher with Auto Tool Installation
# Created by: arjanchaudharyy

echo "=========================================="
echo "   CTXREC Web Interface Launcher"
echo "=========================================="
echo "Created by: arjanchaudharyy"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed."
    exit 1
fi

# Check if running as root (needed for tool installation)
if [[ $EUID -ne 0 ]] && ! command -v httpx &> /dev/null; then
    echo "⚠️  WARNING: Not running as root. Tool installation may fail."
    echo "For best results, run: sudo ./start_web.sh"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Auto-install tools if needed
echo "=========================================="
echo "   Checking & Installing Required Tools"
echo "=========================================="
echo ""

MISSING_TOOLS=()
REQUIRED_TOOLS=(dig curl nmap httpx subfinder nuclei waybackurls dalfox sqlmap dnsx naabu)

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "⚠️  Missing tools detected: ${MISSING_TOOLS[*]}"
    echo ""
    echo "Starting automatic installation..."
    echo "This may take 10-15 minutes depending on your internet connection."
    echo ""
    
    # Check if install script exists
    if [ -f "install_basic_tools.sh" ]; then
        echo "[*] Running install_basic_tools.sh..."
        if [[ $EUID -eq 0 ]]; then
            bash install_basic_tools.sh
        else
            sudo bash install_basic_tools.sh
        fi
    else
        echo "[*] Running garudrecon install..."
        if [[ $EUID -eq 0 ]]; then
            ./garudrecon install -f ALL
        else
            sudo ./garudrecon install -f ALL
        fi
    fi
    
    echo ""
    echo "[✓] Tool installation completed!"
    echo ""
else
    echo "✓ All required tools are already installed!"
    echo ""
fi

# Verify installation
echo "=========================================="
echo "   Tool Installation Summary"
echo "=========================================="
echo ""

INSTALLED=0
TOTAL=${#REQUIRED_TOOLS[@]}

for tool in "${REQUIRED_TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "  ✓ $tool"
        ((INSTALLED++))
    else
        echo "  ✗ $tool (missing)"
    fi
done

echo ""
echo "Installed: $INSTALLED/$TOTAL tools"
echo ""

# Check if virtual environment exists, if not create it
if [ ! -d "venv" ]; then
    echo "[*] Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "[*] Activating virtual environment..."
source venv/bin/activate

# Install/upgrade dependencies
echo "[*] Installing Python dependencies..."
pip install -q --upgrade pip
pip install -q -r requirements.txt

# Create necessary directories
mkdir -p scans

# Check if port 5000 is already in use
if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo ""
    echo "Warning: Port 5000 is already in use."
    echo "Attempting to kill the process..."
    lsof -ti:5000 | xargs kill -9 2>/dev/null
    sleep 2
fi

echo ""
echo "=========================================="
echo "   Starting CTXREC Web Server"
echo "=========================================="
echo ""
echo "✓ Tools: $INSTALLED/$TOTAL installed"
echo "✓ Server starting on port 5000"
echo ""
echo "Access the web interface at:"
echo ""
echo "  → http://localhost:5000"
echo "  → http://127.0.0.1:5000"
echo ""
echo "Features:"
echo "  • Real-time vulnerability scanning"
echo "  • XSS, SQLi, and security testing"
echo "  • Subdomain enumeration"
echo "  • Live log streaming"
echo "  • Detailed results display"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the web backend
python3 web_backend.py
