#!/bin/bash

# Tool Verification Script for GarudRecon
# Checks which tools are installed and provides installation recommendations

echo "=================================================="
echo "GarudRecon Tool Verification"
echo "=================================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Tools required for each scan type
LIGHT_TOOLS=("dig" "nmap" "httpx" "waybackurls" "gau" "dalfox" "sqlmap" "curl")
COOL_TOOLS=("subfinder" "assetfinder" "amass" "dnsx" "httpx" "naabu" "nmap" "waybackurls" "gau" "katana" "subjs" "dalfox" "sqlmap" "subzy" "nuclei" "curl")
ULTRA_TOOLS=("subfinder" "assetfinder" "amass" "findomain" "chaos" "cero" "alterx" "altdns" "puredns" "dnsx" "httpx" "naabu" "masscan" "waybackurls" "gau" "katana" "hakrawler" "gospider" "subjs" "linkfinder" "paramspider" "ffuf" "dalfox" "sqlmap" "nuclei" "subzy" "gowitness" "aquatone" "curl")

BASIC_TOOLS=("dig" "nmap" "curl" "python3" "go")

check_tool() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        return 1
    fi
}

echo "Basic System Tools:"
echo "-------------------"
basic_count=0
basic_total=${#BASIC_TOOLS[@]}
for tool in "${BASIC_TOOLS[@]}"; do
    if check_tool "$tool"; then
        ((basic_count++))
    fi
done
echo ""

echo "Tools for LIGHT Scan:"
echo "---------------------"
light_count=0
light_total=${#LIGHT_TOOLS[@]}
for tool in "${LIGHT_TOOLS[@]}"; do
    if check_tool "$tool"; then
        ((light_count++))
    fi
done
echo ""

echo "Tools for COOL Scan:"
echo "--------------------"
cool_count=0
cool_total=${#COOL_TOOLS[@]}
for tool in "${COOL_TOOLS[@]}"; do
    if check_tool "$tool"; then
        ((cool_count++))
    fi
done
echo ""

echo "Tools for ULTRA Scan:"
echo "---------------------"
ultra_count=0
ultra_total=${#ULTRA_TOOLS[@]}
for tool in "${ULTRA_TOOLS[@]}"; do
    if check_tool "$tool"; then
        ((ultra_count++))
    fi
done
echo ""

echo "=================================================="
echo "Summary:"
echo "=================================================="
echo -e "Basic Tools:  ${basic_count}/${basic_total} installed"
echo -e "Light Scan:   ${light_count}/${light_total} tools installed"
echo -e "Cool Scan:    ${cool_count}/${cool_total} tools installed"
echo -e "Ultra Scan:   ${ultra_count}/${ultra_total} tools installed"
echo ""

if [ $basic_count -lt $basic_total ]; then
    echo -e "${YELLOW}WARNING:${NC} Basic system tools are missing. Please install them first:"
    echo "  apt update && apt install -y dnsutils nmap curl python3 golang"
    echo ""
fi

if [ $light_count -lt $light_total ]; then
    echo -e "${YELLOW}Note:${NC} Some tools for Light scan are missing."
    echo "To install all tools, run:"
    echo "  ./garudrecon install -f ALL"
    echo ""
fi

if [ $ultra_count -lt $ultra_total ]; then
    echo -e "${YELLOW}Note:${NC} Some advanced tools for Ultra scan are missing."
    echo "Full installation may take 30-60 minutes."
    echo ""
fi

echo "=================================================="
