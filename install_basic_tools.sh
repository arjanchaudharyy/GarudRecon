#!/bin/bash

# Quick installer for basic recon tools
# Created by: arjanchaudharyy
# This installs minimal tools needed for scans to work

echo "=================================================="
echo "CTXREC - Installing Basic Tools"
echo "=================================================="
echo "Created by: arjanchaudharyy"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "[+] Updating package lists..."
apt update -qq

echo "[+] Installing system packages..."
apt install -y dnsutils nmap curl wget git golang-go python3 python3-pip jq 2>&1 | grep -E "Setting up|already"

echo ""
echo "[+] Installing Go tools..."

# Set up Go environment
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
mkdir -p $GOPATH/bin

# Install essential Go-based tools
echo "  - httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 2>&1 | tail -1

echo "  - subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>&1 | tail -1

echo "  - dnsx..."
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest 2>&1 | tail -1

echo "  - naabu..."
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest 2>&1 | tail -1

echo "  - nuclei..."
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>&1 | tail -1

echo "  - katana..."
go install -v github.com/projectdiscovery/katana/cmd/katana@latest 2>&1 | tail -1

echo "  - waybackurls..."
go install -v github.com/tomnomnom/waybackurls@latest 2>&1 | tail -1

echo ""
echo "[+] Installing Python tools..."
pip3 install --quiet sqlmap 2>&1 | tail -1

echo ""
echo "=================================================="
echo "Installation complete!"
echo "=================================================="
echo ""
echo "Installed tools will be available at:"
echo "  - System tools: /usr/bin/"
echo "  - Go tools: $GOPATH/bin/"
echo ""
echo "Make sure to add to your PATH:"
echo "  export PATH=\$PATH:\$HOME/go/bin"
echo ""
echo "Run ./check_tools.sh to verify installation"
echo ""
