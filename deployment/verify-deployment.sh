#!/bin/bash

################################################################################
# GarudRecon Deployment Verification Script
# Checks if deployment was successful
################################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS=0
FAIL=0

print_header() {
    echo ""
    echo "=========================================="
    echo "  $1"
    echo "=========================================="
    echo ""
}

check_pass() {
    echo -e "${GREEN}✓ $1${NC}"
    ((PASS++))
}

check_fail() {
    echo -e "${RED}✗ $1${NC}"
    ((FAIL++))
}

check_warn() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_header "GarudRecon Deployment Verification"

# Check 1: Python
echo -n "Checking Python 3... "
if command -v python3 &> /dev/null; then
    VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    check_pass "Python $VERSION found"
else
    check_fail "Python 3 not found"
fi

# Check 2: Pip
echo -n "Checking pip... "
if command -v pip3 &> /dev/null || python3 -m pip --version &> /dev/null; then
    check_pass "pip found"
else
    check_fail "pip not found"
fi

# Check 3: Git
echo -n "Checking Git... "
if command -v git &> /dev/null; then
    check_pass "Git found"
else
    check_warn "Git not found (optional)"
fi

# Check 4: Virtual Environment
echo -n "Checking virtual environment... "
if [ -d "venv" ] || [ -d "../venv" ]; then
    check_pass "Virtual environment exists"
else
    check_warn "Virtual environment not found"
fi

# Check 5: Dependencies
echo -n "Checking Flask... "
if python3 -c "import flask" 2>/dev/null; then
    check_pass "Flask installed"
else
    check_fail "Flask not installed"
fi

echo -n "Checking flask-cors... "
if python3 -c "import flask_cors" 2>/dev/null; then
    check_pass "flask-cors installed"
else
    check_fail "flask-cors not installed"
fi

# Check 6: Application files
print_header "Application Files"

files_to_check=(
    "web_backend.py"
    "start_web.sh"
    "requirements.txt"
    "garudrecon"
    "web/index.html"
    "web/style.css"
    "web/script.js"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ] || [ -f "../$file" ]; then
        check_pass "$file exists"
    else
        check_fail "$file missing"
    fi
done

# Check 7: Scan scripts
print_header "Scan Scripts"

scan_scripts=(
    "cmd/scan_light"
    "cmd/scan_cool"
    "cmd/scan_ultra"
)

for script in "${scan_scripts[@]}"; do
    if [ -f "$script" ] || [ -f "../$script" ]; then
        if [ -x "$script" ] || [ -x "../$script" ]; then
            check_pass "$script is executable"
        else
            check_warn "$script exists but not executable"
        fi
    else
        check_fail "$script missing"
    fi
done

# Check 8: Directories
print_header "Directories"

dirs_to_check=(
    "scans"
    "logs"
    "web"
)

for dir in "${dirs_to_check[@]}"; do
    if [ -d "$dir" ] || [ -d "../$dir" ]; then
        check_pass "$dir/ exists"
    else
        check_warn "$dir/ not found (will be created)"
    fi
done

# Check 9: Systemd service (if running as service)
print_header "System Service"

if systemctl list-units --type=service --all | grep -q "garudrecon"; then
    if systemctl is-active --quiet garudrecon; then
        check_pass "GarudRecon service is running"
    else
        check_warn "GarudRecon service exists but not running"
    fi
else
    check_warn "GarudRecon service not configured (manual mode)"
fi

# Check 10: Nginx
echo -n "Checking Nginx... "
if command -v nginx &> /dev/null; then
    if systemctl is-active --quiet nginx; then
        check_pass "Nginx is running"
    else
        check_warn "Nginx installed but not running"
    fi
else
    check_warn "Nginx not installed (optional)"
fi

# Check 11: Port availability
print_header "Network"

echo -n "Checking port 5000... "
if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    check_pass "Port 5000 is in use (app running)"
else
    check_warn "Port 5000 is available (app not running)"
fi

# Check 12: API Health
print_header "API Health Check"

if curl -s http://localhost:5000/api/health >/dev/null 2>&1; then
    RESPONSE=$(curl -s http://localhost:5000/api/health)
    if echo "$RESPONSE" | grep -q "ok"; then
        check_pass "API health check passed"
    else
        check_fail "API health check failed"
    fi
else
    check_warn "API not accessible (app may not be running)"
fi

# Check 13: Firewall
print_header "Security"

if command -v ufw &> /dev/null; then
    if ufw status | grep -q "Status: active"; then
        check_pass "Firewall is active"
    else
        check_warn "Firewall is inactive"
    fi
else
    check_warn "UFW not installed"
fi

# Check 14: SSL Certificate
if [ ! -z "$DOMAIN" ]; then
    if [ -d "/etc/letsencrypt/live/$DOMAIN" ]; then
        check_pass "SSL certificate found"
    else
        check_warn "No SSL certificate"
    fi
fi

# Summary
print_header "Verification Summary"

TOTAL=$((PASS + FAIL))
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    echo ""
    echo "Your GarudRecon deployment looks good!"
    echo ""
    echo "Next steps:"
    if ! systemctl is-active --quiet garudrecon && ! lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "  1. Start the application: ./start_web.sh"
    fi
    echo "  2. Access the web interface"
    echo "  3. Try a Light scan"
    echo "  4. Review the documentation"
    exit 0
else
    echo -e "${RED}✗ Some checks failed!${NC}"
    echo ""
    echo "Please fix the issues above before using GarudRecon."
    echo ""
    echo "Common fixes:"
    echo "  - Install Python dependencies: pip3 install -r requirements.txt"
    echo "  - Make scripts executable: chmod +x garudrecon cmd/scan_* start_web.sh"
    echo "  - Create directories: mkdir -p scans logs"
    exit 1
fi
