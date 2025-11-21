#!/bin/bash

# Test Railway Deployment
# This script verifies that all tools are installed correctly

echo "==========================================="
echo "Railway Deployment Test"
echo "==========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running in Docker/Railway
if [ -f /.dockerenv ] || [ -n "$RAILWAY_ENVIRONMENT" ]; then
    echo -e "${GREEN}✓ Running in containerized environment${NC}"
    echo "  Environment: $([ -n "$RAILWAY_ENVIRONMENT" ] && echo "Railway" || echo "Docker")"
else
    echo -e "${YELLOW}⚠ Not running in container${NC}"
    echo "  This test is designed for Railway/Docker deployments"
fi

echo ""
echo "-------------------------------------------"
echo "Testing System Tools"
echo "-------------------------------------------"

system_tools=("dig" "nmap" "curl" "wget" "git" "jq")
system_pass=0
system_fail=0

for tool in "${system_tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $tool - $(which $tool)"
        ((system_pass++))
    else
        echo -e "${RED}✗${NC} $tool - NOT FOUND"
        ((system_fail++))
    fi
done

echo ""
echo "-------------------------------------------"
echo "Testing Go Tools"
echo "-------------------------------------------"

go_tools=("httpx" "subfinder" "dnsx" "naabu" "nuclei" "katana" "waybackurls" "gau" "assetfinder" "dalfox")
go_pass=0
go_fail=0

for tool in "${go_tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $tool - $(which $tool)"
        ((go_pass++))
    else
        echo -e "${RED}✗${NC} $tool - NOT FOUND"
        ((go_fail++))
    fi
done

echo ""
echo "-------------------------------------------"
echo "Testing Python Tools"
echo "-------------------------------------------"

if command -v sqlmap &> /dev/null; then
    echo -e "${GREEN}✓${NC} sqlmap - $(which sqlmap)"
    python_pass=1
else
    echo -e "${RED}✗${NC} sqlmap - NOT FOUND"
    python_pass=0
fi

echo ""
echo "-------------------------------------------"
echo "Testing Flask Backend"
echo "-------------------------------------------"

if python3 -c "import flask" &> /dev/null; then
    echo -e "${GREEN}✓${NC} Flask is installed"
    flask_ok=1
else
    echo -e "${RED}✗${NC} Flask is NOT installed"
    flask_ok=0
fi

if python3 -c "import flask_cors" &> /dev/null; then
    echo -e "${GREEN}✓${NC} flask-cors is installed"
else
    echo -e "${RED}✗${NC} flask-cors is NOT installed"
    flask_ok=0
fi

echo ""
echo "-------------------------------------------"
echo "Testing Scan Scripts"
echo "-------------------------------------------"

scan_scripts=("./cmd/scan_light" "./cmd/scan_cool" "./cmd/scan_ultra")
script_pass=0
script_fail=0

for script in "${scan_scripts[@]}"; do
    if [ -x "$script" ]; then
        echo -e "${GREEN}✓${NC} $script - executable"
        ((script_pass++))
    elif [ -f "$script" ]; then
        echo -e "${YELLOW}⚠${NC} $script - exists but not executable"
        ((script_fail++))
    else
        echo -e "${RED}✗${NC} $script - NOT FOUND"
        ((script_fail++))
    fi
done

echo ""
echo "==========================================="
echo "Test Summary"
echo "==========================================="
echo ""

total_pass=$((system_pass + go_pass + python_pass + script_pass + flask_ok))
total_fail=$((system_fail + go_fail + (1 - python_pass) + script_fail + (1 - flask_ok)))
total_tests=$((total_pass + total_fail))

echo "System Tools: $system_pass/${#system_tools[@]} passed"
echo "Go Tools:     $go_pass/${#go_tools[@]} passed"
echo "Python Tools: $python_pass/1 passed"
echo "Flask Setup:  $([ $flask_ok -eq 1 ] && echo "OK" || echo "FAILED")"
echo "Scan Scripts: $script_pass/${#scan_scripts[@]} executable"
echo ""
echo "-------------------------------------------"
echo -e "Overall: $total_pass/$total_tests tests passed"
echo "-------------------------------------------"

if [ $total_fail -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
    echo ""
    echo "Your Railway deployment is ready!"
    echo "Scans should work correctly."
    exit 0
elif [ $go_fail -gt 0 ]; then
    echo -e "${RED}✗ CRITICAL: Go tools are missing${NC}"
    echo ""
    echo "This will cause scans to show 0 results."
    echo ""
    echo "Solution:"
    echo "1. Verify Dockerfile includes Go tool installation"
    echo "2. Redeploy on Railway (Dashboard → ⋮ → Redeploy)"
    echo "3. Wait 5-10 minutes for tools to compile"
    echo "4. Check build logs for errors"
    echo ""
    echo "See: RAILWAY_QUICK_FIX.md for detailed troubleshooting"
    exit 1
else
    echo -e "${YELLOW}⚠ PARTIAL: Some tools are missing${NC}"
    echo ""
    echo "Scans may work but with limited functionality."
    echo "See: RAILWAY_DEPLOYMENT_GUIDE.md"
    exit 1
fi
