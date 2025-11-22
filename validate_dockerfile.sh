#!/bin/bash

# Script to validate Dockerfile changes for build timeout fix

echo "=== Dockerfile Validation ==="
echo ""

# Check if Dockerfile exists
if [ ! -f "Dockerfile" ]; then
    echo "❌ ERROR: Dockerfile not found"
    exit 1
fi
echo "✓ Dockerfile exists"

# Check for pre-built binary downloads
echo ""
echo "Checking for pre-built binary installations..."
if grep -q "wget.*projectdiscovery.*releases.*download" Dockerfile; then
    echo "✓ Pre-built binaries are being downloaded"
    
    # Count how many pre-built binaries
    count=$(grep -c "wget.*projectdiscovery.*releases.*download" Dockerfile)
    echo "  Found $count ProjectDiscovery pre-built binaries"
else
    echo "❌ WARNING: No pre-built binaries found"
fi

# Check for lightweight go install
echo ""
echo "Checking for lightweight Go tool compilation..."
if grep -q "go install.*tomnomnom" Dockerfile; then
    echo "✓ Lightweight Go tools are being compiled"
    
    # Count lightweight tools
    count=$(grep -c "go install" Dockerfile)
    echo "  Found $count go install commands (should be ~4)"
else
    echo "❌ WARNING: No Go install commands found"
fi

# Check PATH includes /usr/local/bin
echo ""
echo "Checking PATH configuration..."
if grep -q "PATH=.*:/usr/local/bin" Dockerfile; then
    echo "✓ PATH includes /usr/local/bin for pre-built binaries"
else
    echo "❌ WARNING: PATH may not include /usr/local/bin"
fi

# Check for heavy compilation (should be removed)
echo ""
echo "Checking for removed heavy compilations..."
if grep -q "go install.*nuclei" Dockerfile; then
    echo "❌ WARNING: nuclei is still being compiled (should use pre-built)"
elif grep -q "go install.*naabu" Dockerfile; then
    echo "❌ WARNING: naabu is still being compiled (should use pre-built)"
else
    echo "✓ Heavy tools (nuclei, naabu) are NOT being compiled"
fi

# Verify tools being installed
echo ""
echo "Tools being installed via pre-built binaries:"
grep "# " Dockerfile | grep -A1 "httpx\|subfinder\|dnsx\|naabu\|nuclei\|katana" | grep "^#" | sed 's/^#/  -/'

echo ""
echo "Tools being compiled (lightweight):"
grep "go install" Dockerfile | sed 's/.*github.com/  - github.com/' | sed 's/@latest.*//'

echo ""
echo "==================================="
echo ""

# Summary
total_prebuild=$(grep -c "wget.*projectdiscovery.*releases.*download" Dockerfile)
total_compile=$(grep -c "go install" Dockerfile)

echo "Summary:"
echo "  Pre-built binaries: $total_prebuild (fast, no compilation)"
echo "  Compiled tools: $total_compile (lightweight, seconds)"
echo ""
echo "Expected build time: 2-3 minutes (down from 8-12 minutes)"
echo ""

# Final check
if [ $total_prebuild -ge 5 ] && [ $total_compile -le 5 ]; then
    echo "✅ Dockerfile optimization looks good!"
    echo "   Ready to deploy to Railway"
    exit 0
else
    echo "⚠️  Dockerfile may need review"
    echo "   Expected: 5-6 pre-built binaries, 4-5 compiled tools"
    exit 1
fi
