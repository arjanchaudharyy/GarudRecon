#!/bin/bash

# Auto-installer for CTXREC reconnaissance tools
# Automatically downloads and installs required tools
# Created by: arjanchaudharyy

INSTALL_LOG="/tmp/ctxrec_install.log"
INSTALL_DIR="$HOME/.ctxrec/tools"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1" | tee -a "$INSTALL_LOG"
}

warn() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')]${NC} $1" | tee -a "$INSTALL_LOG"
}

error() {
    echo -e "${RED}[$(date +'%H:%M:%S')]${NC} $1" | tee -a "$INSTALL_LOG"
}

# Check if running with sufficient privileges
check_privileges() {
    if [ "$EUID" -eq 0 ]; then
        USE_SUDO=""
    else
        USE_SUDO="sudo"
    fi
}

# Install system packages
install_system_tools() {
    log "Installing system tools..."
    
    # Check if apt is available
    if command -v apt &> /dev/null; then
        $USE_SUDO apt update -qq >> "$INSTALL_LOG" 2>&1
        $USE_SUDO apt install -y dnsutils nmap curl wget git jq python3 python3-pip >> "$INSTALL_LOG" 2>&1
    elif command -v yum &> /dev/null; then
        $USE_SUDO yum install -y bind-utils nmap curl wget git jq python3 python3-pip >> "$INSTALL_LOG" 2>&1
    elif command -v brew &> /dev/null; then
        brew install bind nmap curl wget git jq python3 >> "$INSTALL_LOG" 2>&1
    else
        error "No supported package manager found. Please install tools manually."
        return 1
    fi
    
    log "✓ System tools installed"
}

# Install Go if not present
install_go() {
    if command -v go &> /dev/null; then
        log "✓ Go already installed"
        return 0
    fi
    
    log "Installing Go language..."
    
    GO_VERSION="1.21.5"
    GO_OS="linux"
    GO_ARCH="amd64"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        GO_OS="darwin"
    fi
    
    # Download Go
    cd /tmp
    wget -q "https://go.dev/dl/go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz" >> "$INSTALL_LOG" 2>&1
    
    if [ $? -eq 0 ]; then
        $USE_SUDO rm -rf /usr/local/go
        $USE_SUDO tar -C /usr/local -xzf "go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz" >> "$INSTALL_LOG" 2>&1
        rm "go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz"
        
        # Set up Go environment
        export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
        export GOPATH=$HOME/go
        
        log "✓ Go installed successfully"
        return 0
    else
        error "Failed to download Go"
        return 1
    fi
}

# Install Go-based reconnaissance tools
install_go_tools() {
    log "Installing Go-based reconnaissance tools..."
    
    # Ensure Go paths are set
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    export GOPATH=$HOME/go
    mkdir -p $GOPATH/bin
    
    # Array of tools to install
    declare -A GO_TOOLS=(
        ["httpx"]="github.com/projectdiscovery/httpx/cmd/httpx@latest"
        ["subfinder"]="github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
        ["dnsx"]="github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
        ["naabu"]="github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
        ["nuclei"]="github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
        ["katana"]="github.com/projectdiscovery/katana/cmd/katana@latest"
        ["waybackurls"]="github.com/tomnomnom/waybackurls@latest"
        ["gau"]="github.com/lc/gau/v2/cmd/gau@latest"
        ["assetfinder"]="github.com/tomnomnom/assetfinder@latest"
        ["dalfox"]="github.com/hahwul/dalfox/v2@latest"
    )
    
    for tool in "${!GO_TOOLS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log "  Installing $tool..."
            go install -v "${GO_TOOLS[$tool]}" >> "$INSTALL_LOG" 2>&1
            if [ $? -eq 0 ]; then
                log "    ✓ $tool installed"
            else
                warn "    ✗ Failed to install $tool"
            fi
        else
            log "  ✓ $tool already installed"
        fi
    done
}

# Install Python-based tools
install_python_tools() {
    log "Installing Python-based tools..."
    
    # Check if pip3 is available
    if ! command -v pip3 &> /dev/null; then
        error "pip3 not found. Please install Python 3 and pip first."
        return 1
    fi
    
    # Install Flask and dependencies
    pip3 install --quiet --user flask flask-cors >> "$INSTALL_LOG" 2>&1
    log "✓ Flask installed"
    
    # Install sqlmap if not present
    if ! command -v sqlmap &> /dev/null; then
        log "  Installing sqlmap..."
        pip3 install --quiet --user sqlmap >> "$INSTALL_LOG" 2>&1
        log "    ✓ sqlmap installed"
    else
        log "  ✓ sqlmap already installed"
    fi
}

# Update PATH in shell config
update_path() {
    log "Updating PATH configuration..."
    
    SHELL_RC="$HOME/.bashrc"
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_RC="$HOME/.zshrc"
    fi
    
    # Add Go paths if not already present
    if ! grep -q "/usr/local/go/bin" "$SHELL_RC" 2>/dev/null; then
        echo '' >> "$SHELL_RC"
        echo '# CTXREC Tool Paths (added by auto-installer)' >> "$SHELL_RC"
        echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$SHELL_RC"
        echo 'export GOPATH=$HOME/go' >> "$SHELL_RC"
        log "✓ PATH updated in $SHELL_RC"
    else
        log "✓ PATH already configured"
    fi
}

# Main installation function
main() {
    echo "=========================================="
    echo "CTXREC Auto-Installer"
    echo "Created by: arjanchaudharyy"
    echo "=========================================="
    echo ""
    
    # Clear old log
    > "$INSTALL_LOG"
    
    log "Starting automatic tool installation..."
    log "Installation log: $INSTALL_LOG"
    echo ""
    
    check_privileges
    
    # Install components
    install_system_tools
    sleep 1
    
    install_go
    sleep 1
    
    install_go_tools
    sleep 1
    
    install_python_tools
    sleep 1
    
    update_path
    
    echo ""
    echo "=========================================="
    log "Installation complete!"
    echo "=========================================="
    echo ""
    log "Installed tools are available at:"
    log "  - System tools: /usr/bin/"
    log "  - Go tools: $HOME/go/bin/"
    log "  - Python tools: $HOME/.local/bin/"
    echo ""
    log "Please restart your terminal or run:"
    log "  source ~/.bashrc"
    echo ""
    log "Full installation log: $INSTALL_LOG"
    echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
