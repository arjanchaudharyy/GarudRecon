#!/bin/bash

################################################################################
# GarudRecon - Docker Deployment Script
# Quick deployment using Docker Compose
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    echo -e "${2}${1}${NC}"
}

print_header() {
    echo ""
    echo "=========================================="
    echo "  $1"
    echo "=========================================="
    echo ""
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_message "Docker not found. Installing..." "$BLUE"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        print_message "✓ Docker installed" "$GREEN"
    else
        print_message "✓ Docker is already installed" "$GREEN"
    fi
}

# Check if Docker Compose is installed
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        print_message "Docker Compose not found. Installing..." "$BLUE"
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
            -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        print_message "✓ Docker Compose installed" "$GREEN"
    else
        print_message "✓ Docker Compose is already installed" "$GREEN"
    fi
}

# Clone repository
clone_repository() {
    if [ ! -d "GarudRecon" ]; then
        print_message "Cloning GarudRecon..." "$BLUE"
        git clone https://github.com/rix4uni/GarudRecon.git
        cd GarudRecon
    else
        print_message "Repository already exists, pulling latest..." "$BLUE"
        cd GarudRecon
        git pull
    fi
    print_message "✓ Repository ready" "$GREEN"
}

# Build and start
deploy() {
    print_header "Building and Starting Containers"
    
    # Build the image
    print_message "Building Docker image..." "$BLUE"
    docker-compose build
    
    # Start containers
    print_message "Starting containers..." "$BLUE"
    docker-compose up -d
    
    # Wait for container to be ready
    sleep 5
    
    # Check status
    docker-compose ps
    
    print_message "✓ Deployment complete!" "$GREEN"
}

# Print access information
print_info() {
    print_header "Deployment Information"
    
    IP=$(curl -s ifconfig.me || echo "localhost")
    
    echo "GarudRecon is now running!"
    echo ""
    echo "Access the web interface:"
    echo "  → http://localhost:5000"
    echo "  → http://${IP}:5000"
    echo ""
    echo "Useful commands:"
    echo "  Status:    docker-compose ps"
    echo "  Logs:      docker-compose logs -f"
    echo "  Stop:      docker-compose stop"
    echo "  Start:     docker-compose start"
    echo "  Restart:   docker-compose restart"
    echo "  Shutdown:  docker-compose down"
    echo ""
    echo "To access scan results:"
    echo "  ls -la scans/"
    echo ""
}

# Main
main() {
    print_header "GarudRecon - Docker Deployment"
    
    check_docker
    check_docker_compose
    clone_repository
    deploy
    print_info
    
    print_message "Happy Scanning! 🚀" "$GREEN"
}

main
