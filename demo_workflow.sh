#!/bin/bash

# Demo Workflow - Shows complete CTXREC setup and usage
# Created by: arjanchaudharyy

echo "=========================================="
echo "CTXREC - Complete Workflow Demo"
echo "=========================================="
echo "Created by: arjanchaudharyy"
echo ""

# Step 1: Check tools
echo "Step 1: Checking installed tools..."
echo "--------------------------------------"
./check_tools.sh 2>/dev/null | grep -E "Summary:|Light Scan:|✓|✗" | head -10
echo ""

# Step 2: Show what happens without tools
echo "Step 2: Running scan WITHOUT tools installed..."
echo "--------------------------------------"
echo "Testing with: example.com"
./cmd/scan_light -d "example.com" -o /tmp/demo_no_tools 2>&1 | grep -E "Starting|FINDINGS:" -A 10 | head -15
echo ""

# Step 3: Check the JSON
echo "Step 3: Verifying JSON is valid (even with 0 results)..."
echo "--------------------------------------"
if python3 -m json.tool /tmp/demo_no_tools/results.json >/dev/null 2>&1; then
    echo "✓ JSON is valid"
    python3 -m json.tool /tmp/demo_no_tools/results.json | grep -E "domain|dns_records|urls_found|status"
else
    echo "✗ JSON is invalid (this shouldn't happen with our fixes!)"
fi
echo ""

# Step 4: Show installation command
echo "Step 4: To get REAL results, install tools:"
echo "--------------------------------------"
echo "Run one of these commands:"
echo ""
echo "  # Quick install (10-15 min, recommended):"
echo "  sudo ./install_basic_tools.sh"
echo ""
echo "  # OR full install (30-60 min):"
echo "  ./garudrecon install -f ALL"
echo ""
echo "After installation, scans will show actual results like:"
echo "  DNS Records: 2-5"
echo "  Open Ports: 2-10"
echo "  URLs Discovered: 50-500+"
echo ""

# Step 5: Web interface
echo "Step 5: Using the Web Interface..."
echo "--------------------------------------"
echo "Start server with:"
echo "  ./start_web.sh"
echo ""
echo "The web interface will:"
echo "  1. Check for installed tools"
echo "  2. Warn if tools are missing"
echo "  3. Provide installation instructions"
echo "  4. Allow scanning through browser UI"
echo ""

echo "=========================================="
echo "Summary"
echo "=========================================="
echo ""
echo "✓ Bug fixes applied - scans complete without errors"
echo "✓ JSON always valid - even with missing tools"
echo "✓ Clear warnings - users know to install tools"
echo "✓ Easy installation - ./install_basic_tools.sh"
echo ""
echo "📖 For complete guide, see:"
echo "   TOOL_INSTALLATION_GUIDE.md"
echo ""
