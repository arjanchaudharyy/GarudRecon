FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and reconnaissance tools
RUN apt-get update && apt-get install -y \
    # Python and build tools
    python3 \
    python3-pip \
    python3-venv \
    # Version control and downloaders
    git \
    curl \
    wget \
    unzip \
    # Build essentials for Go compilation
    build-essential \
    gcc \
    g++ \
    make \
    # Library for network tools (naabu, etc.)
    libpcap-dev \
    # DNS and network tools
    dnsutils \
    nmap \
    # Additional utilities
    jq \
    netcat \
    whois \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Go (lightweight version, only for small tools)
ENV GO_VERSION=1.23.5
ENV GOPATH=/root/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:/usr/local/bin

# Install Go for lightweight tools only
RUN cd /tmp && \
    wget -q --show-progress https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz && \
    go version

# Install pre-built binaries (FAST - no compilation needed)
RUN echo "=== Installing pre-built tools (fast) ===" && \
    mkdir -p /usr/local/bin && \
    # httpx
    wget -q https://github.com/projectdiscovery/httpx/releases/latest/download/httpx_linux_amd64.zip && \
    unzip -q httpx_linux_amd64.zip && mv httpx /usr/local/bin/ && rm httpx_linux_amd64.zip && \
    # subfinder
    wget -q https://github.com/projectdiscovery/subfinder/releases/latest/download/subfinder_linux_amd64.zip && \
    unzip -q subfinder_linux_amd64.zip && mv subfinder /usr/local/bin/ && rm subfinder_linux_amd64.zip && \
    # dnsx
    wget -q https://github.com/projectdiscovery/dnsx/releases/latest/download/dnsx_linux_amd64.zip && \
    unzip -q dnsx_linux_amd64.zip && mv dnsx /usr/local/bin/ && rm dnsx_linux_amd64.zip && \
    # naabu
    wget -q https://github.com/projectdiscovery/naabu/releases/latest/download/naabu_linux_amd64.zip && \
    unzip -q naabu_linux_amd64.zip && mv naabu /usr/local/bin/ && rm naabu_linux_amd64.zip && \
    # nuclei
    wget -q https://github.com/projectdiscovery/nuclei/releases/latest/download/nuclei_linux_amd64.zip && \
    unzip -q nuclei_linux_amd64.zip && mv nuclei /usr/local/bin/ && rm nuclei_linux_amd64.zip && \
    # katana
    wget -q https://github.com/projectdiscovery/katana/releases/latest/download/katana_linux_amd64.zip && \
    unzip -q katana_linux_amd64.zip && mv katana /usr/local/bin/ && rm katana_linux_amd64.zip && \
    chmod +x /usr/local/bin/* && \
    echo "✓ Pre-built tools installed"

# Install lightweight Go tools (FAST - small compilation)
RUN echo "=== Installing lightweight Go tools ===" && \
    mkdir -p $GOPATH/bin && \
    go install -v github.com/tomnomnom/waybackurls@latest && \
    go install -v github.com/tomnomnom/assetfinder@latest && \
    go install -v github.com/tomnomnom/anew@latest && \
    go install -v github.com/lc/gau/v2/cmd/gau@latest && \
    echo "✓ Lightweight tools complete"

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Install Python-based security tools
RUN pip3 install --no-cache-dir sqlmap

# Make scripts executable
RUN chmod +x /app/cmd/scan_* /app/*.sh /app/web_backend.py /app/docker-entrypoint.sh 2>/dev/null || true

# Create output directory
RUN mkdir -p /app/scans

# Verify tool installation
RUN echo "=== Verifying tool installation ===" && \
    echo "System tools:" && \
    which dig nmap curl wget git jq || true && \
    echo "Pre-built tools:" && \
    which httpx subfinder dnsx naabu nuclei katana || true && \
    echo "Go-based tools:" && \
    which waybackurls gau assetfinder anew || true && \
    echo "Python tools:" && \
    which sqlmap || true && \
    echo "==================================="

# Expose port (Railway will set PORT env var)
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:${PORT:-5000}/api/health || exit 1

# Use entrypoint script for startup verification
ENTRYPOINT ["/app/docker-entrypoint.sh"]
