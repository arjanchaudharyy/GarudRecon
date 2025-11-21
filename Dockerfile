FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Make scripts executable
RUN chmod +x /app/cmd/scan_* /app/start_web.sh /app/web_backend.py

# Create output directory
RUN mkdir -p /app/scans

# Expose port
EXPOSE 5000

# Start the web server
CMD ["python3", "web_backend.py"]
