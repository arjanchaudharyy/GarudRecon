#!/bin/bash

# Docker entrypoint script for GarudRecon
# Verifies tools and starts the web backend

echo "==========================================="
echo "GarudRecon - Starting Container"
echo "==========================================="
echo ""

# Quick tool check
echo "Verifying essential tools..."
MISSING_TOOLS=0

for tool in dig httpx subfinder nuclei; do
    if ! command -v "$tool" &> /dev/null; then
        echo "⚠️  Missing: $tool"
        MISSING_TOOLS=$((MISSING_TOOLS + 1))
    fi
done

if [ $MISSING_TOOLS -eq 0 ]; then
    echo "✅ All essential tools are available"
else
    echo "⚠️  WARNING: $MISSING_TOOLS tools are missing"
    echo "Scans may show 0 results. Check build logs."
fi

echo ""
echo "Starting web backend on port ${PORT:-5000}..."
echo "==========================================="
echo ""

# Start the web backend
exec python3 web_backend.py
