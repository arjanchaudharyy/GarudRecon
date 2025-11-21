#!/bin/bash

# Startup Check Script for GarudRecon Web Interface
# Verifies tools and provides warnings before starting the server

echo "=================================================="
echo "GarudRecon Web Interface - Startup Check"
echo "=================================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python and Flask
echo "Checking requirements..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 not found${NC}"
    exit 1
fi

if ! python3 -c "import flask" 2>/dev/null; then
    echo -e "${YELLOW}⚠ Flask not installed${NC}"
    echo "  Installing Flask..."
    pip3 install flask flask-cors 2>&1 | tail -1
fi

echo -e "${GREEN}✓ Python and Flask ready${NC}"
echo ""

# Check for basic tools
echo "Checking recon tools..."
TOOL_COUNT=0
TOTAL_TOOLS=0

BASIC_TOOLS=("dig" "nmap" "curl" "httpx" "subfinder" "nuclei")

for tool in "${BASIC_TOOLS[@]}"; do
    ((TOTAL_TOOLS++))
    if command -v "$tool" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $tool"
        ((TOOL_COUNT++))
    else
        echo -e "  ${RED}✗${NC} $tool"
    fi
done

echo ""
echo "Tools available: $TOOL_COUNT/$TOTAL_TOOLS"
echo ""

if [ $TOOL_COUNT -eq 0 ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}WARNING: NO RECONNAISSANCE TOOLS INSTALLED!${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Scans will complete but produce NO RESULTS (all 0s)."
    echo ""
    echo "To install tools, run ONE of these commands:"
    echo ""
    echo "  1. Quick install (recommended):"
    echo -e "     ${GREEN}sudo ./install_basic_tools.sh${NC}"
    echo ""
    echo "  2. Full install (30-60 minutes):"
    echo -e "     ${GREEN}./garudrecon install -f ALL${NC}"
    echo ""
    echo "  3. Check what's installed:"
    echo -e "     ${GREEN}./check_tools.sh${NC}"
    echo ""
    echo -e "${YELLOW}Press Ctrl+C to cancel, or wait 10 seconds to continue anyway...${NC}"
    sleep 10
elif [ $TOOL_COUNT -lt 3 ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}WARNING: FEW TOOLS INSTALLED${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Scans will work but may produce limited results."
    echo ""
    echo "For better results, install more tools:"
    echo -e "  ${GREEN}sudo ./install_basic_tools.sh${NC}"
    echo ""
    echo "Continuing in 5 seconds..."
    sleep 5
else
    echo -e "${GREEN}✓ Sufficient tools installed for basic scans${NC}"
fi

echo ""
echo "=================================================="
echo "Starting GarudRecon Web Interface..."
echo "=================================================="
echo ""

# Start the web backend
python3 web_backend.py
