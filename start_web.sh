#!/bin/bash

echo "=========================================="
echo "   GarudRecon Web Interface Launcher"
echo "=========================================="
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
echo "   Starting GarudRecon Web Server"
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
