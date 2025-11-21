#!/bin/bash

echo "=========================================="
echo "   GarudRecon Web Interface Test"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check if Python 3 is available
echo -n "Testing Python 3... "
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓ Found${NC}"
else
    echo -e "${RED}✗ Not found${NC}"
    echo "Please install Python 3"
    exit 1
fi

# Test 2: Check if required files exist
echo -n "Testing required files... "
if [[ -f "web_backend.py" ]] && [[ -f "start_web.sh" ]] && [[ -f "requirements.txt" ]]; then
    echo -e "${GREEN}✓ All files present${NC}"
else
    echo -e "${RED}✗ Missing files${NC}"
    exit 1
fi

# Test 3: Check if scan scripts exist and are executable
echo -n "Testing scan scripts... "
if [[ -x "cmd/scan_light" ]] && [[ -x "cmd/scan_cool" ]] && [[ -x "cmd/scan_ultra" ]]; then
    echo -e "${GREEN}✓ All scripts ready${NC}"
else
    echo -e "${YELLOW}⚠ Making scripts executable${NC}"
    chmod +x cmd/scan_light cmd/scan_cool cmd/scan_ultra
fi

# Test 4: Check if web directory exists
echo -n "Testing web directory... "
if [[ -d "web" ]] && [[ -f "web/index.html" ]]; then
    echo -e "${GREEN}✓ Web files present${NC}"
else
    echo -e "${RED}✗ Web directory missing${NC}"
    exit 1
fi

# Test 5: Create necessary directories
echo -n "Creating output directories... "
mkdir -p scans
echo -e "${GREEN}✓ Created${NC}"

# Test 6: Test API endpoints (if server is running)
echo ""
echo "Checking if server is running on port 5000..."
if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Server is running${NC}"
    echo ""
    echo "Testing API endpoints..."
    
    # Test health endpoint
    echo -n "  Health check... "
    RESPONSE=$(curl -s http://localhost:5000/api/health)
    if echo "$RESPONSE" | grep -q "ok"; then
        echo -e "${GREEN}✓ OK${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
    fi
    
    # Test scans endpoint
    echo -n "  List scans... "
    RESPONSE=$(curl -s http://localhost:5000/api/scans)
    if echo "$RESPONSE" | grep -q "scans"; then
        echo -e "${GREEN}✓ OK${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Server not running${NC}"
    echo ""
    echo "To start the server, run:"
    echo "  ./start_web.sh"
    echo "or"
    echo "  ./garudrecon web"
fi

echo ""
echo "=========================================="
echo "   Test Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Start server: ./start_web.sh"
echo "  2. Open browser: http://localhost:5000"
echo "  3. Enter a domain and start scanning"
echo ""
echo "Documentation:"
echo "  - QUICKSTART.md - For beginners"
echo "  - WEB_INTERFACE.md - Detailed guide"
echo "  - README.md - Full documentation"
echo ""
