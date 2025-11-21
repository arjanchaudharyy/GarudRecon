#!/bin/bash

# CTXREC Web Interface Launcher
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

# Check if virtual environment exists, if not create it
if [ ! -d "venv" ]; then
    echo "[*] Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "[*] Activating virtual environment..."
source venv/bin/activate

# Install/upgrade dependencies
echo "[*] Installing dependencies..."
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
echo "   Checking Tools Installation"
echo "=========================================="
echo ""

# Quick tool check
TOOL_COUNT=0
for tool in dig curl httpx subfinder nuclei; do
    command -v "$tool" &> /dev/null && ((TOOL_COUNT++))
done

if [ $TOOL_COUNT -eq 0 ]; then
    echo "⚠️  WARNING: No reconnaissance tools installed!"
    echo ""
    echo "Scans will complete but show 0 results."
    echo "To install basic tools, run:"
    echo "  sudo ./install_basic_tools.sh"
    echo ""
    echo "Or check: ./check_tools.sh"
    echo ""
else
    echo "✓ Found $TOOL_COUNT/5 basic tools installed"
    echo ""
fi

echo "=========================================="
echo "   Starting CTXREC Web Server"
echo "=========================================="
echo ""
echo "Access the web interface at:"
echo ""
echo "  → http://localhost:5000"
echo "  → http://127.0.0.1:5000"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the web backend
python3 web_backend.py
