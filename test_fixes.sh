#!/bin/bash

# Test script to verify all fixes for scan_light, scan_cool, and scan_ultra

echo "Testing scan scripts for missing file handling and JSON validity..."
echo "=================================================================="
echo ""

# Test 1: scan_light with missing tools (should create empty files and valid JSON)
echo "Test 1: scan_light with domain including protocol and trailing slash"
rm -rf /tmp/test_light_1
./cmd/scan_light -d "https://test.example.com/" -o /tmp/test_light_1 2>&1 > /dev/null
if python3 -m json.tool /tmp/test_light_1/results.json > /dev/null 2>&1; then
    echo "✓ scan_light produces valid JSON even with protocol in domain"
else
    echo "✗ scan_light JSON is invalid"
    exit 1
fi

# Test 2: scan_cool with invalid domain
echo "Test 2: scan_cool with invalid domain"
rm -rf /tmp/test_cool_1
./cmd/scan_cool -d "nonexistent.invalid.test" -o /tmp/test_cool_1 2>&1 > /dev/null
if python3 -m json.tool /tmp/test_cool_1/results.json > /dev/null 2>&1; then
    echo "✓ scan_cool produces valid JSON even with invalid domain"
else
    echo "✗ scan_cool JSON is invalid"
    exit 1
fi

# Test 3: scan_ultra with basic domain
echo "Test 3: scan_ultra with basic domain (5 second timeout)"
rm -rf /tmp/test_ultra_1
timeout 5 ./cmd/scan_ultra -d "test.com" -o /tmp/test_ultra_1 2>&1 > /dev/null
if python3 -m json.tool /tmp/test_ultra_1/results.json > /dev/null 2>&1; then
    echo "✓ scan_ultra produces valid JSON"
else
    echo "✗ scan_ultra JSON is invalid"
    exit 1
fi

# Test 4: Check that all expected files are created (even if empty)
echo "Test 4: Verify required files are created"
if [[ -f /tmp/test_light_1/dns_a_records.txt ]] && [[ -f /tmp/test_light_1/urls.txt ]]; then
    echo "✓ scan_light creates required files"
else
    echo "✗ scan_light missing required files"
    exit 1
fi

# Test 5: Check for file operation errors in scan output
echo "Test 5: Check for file operation errors"
if ./cmd/scan_light -d "test.com" -o /tmp/test_light_2 2>&1 | grep -q "No such file or directory"; then
    echo "✗ scan_light still has file operation errors"
    exit 1
else
    echo "✓ scan_light has no file operation errors"
fi

echo ""
echo "=================================================================="
echo "All tests passed! ✓"
echo "=================================================================="
