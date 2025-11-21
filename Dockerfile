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

# Install Go 1.23.5 (latest stable)
ENV GO_VERSION=1.23.5
ENV GOPATH=/root/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
ENV CGO_ENABLED=1
ENV GOPROXY=https://proxy.golang.org,direct
ENV GOTIMEOUT=10m

RUN cd /tmp && \
    wget --progress=dot:giga https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz && \
    go version

# Install Go-based reconnaissance tools (in smaller batches for better error handling)
RUN mkdir -p $GOPATH/bin

# Batch 1: ProjectDiscovery core tools
RUN echo "=== Installing ProjectDiscovery tools ===" && \
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest && \
    echo "✓ Batch 1 complete"

# Batch 2: More ProjectDiscovery tools
RUN echo "=== Installing naabu and nuclei ===" && \
    go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest && \
    go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \
    go install -v github.com/projectdiscovery/katana/cmd/katana@latest && \
    echo "✓ Batch 2 complete"

# Batch 3: TomNomNom tools
RUN echo "=== Installing TomNomNom tools ===" && \
    go install -v github.com/tomnomnom/waybackurls@latest && \
    go install -v github.com/tomnomnom/assetfinder@latest && \
    go install -v github.com/tomnomnom/gf@latest && \
    go install -v github.com/tomnomnom/anew@latest && \
    echo "✓ Batch 3 complete"

# Batch 4: Additional tools
RUN echo "=== Installing additional tools ===" && \
    go install -v github.com/lc/gau/v2/cmd/gau@latest && \
    go install -v github.com/hahwul/dalfox/v2@latest && \
    echo "✓ Batch 4 complete"

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
    echo "Go tools:" && \
    which httpx subfinder dnsx naabu nuclei katana waybackurls gau assetfinder dalfox || true && \
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
