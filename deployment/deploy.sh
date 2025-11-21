#!/bin/bash

################################################################################
# GarudRecon Web Interface - Automated Deployment Script
# This script automates the deployment process on a fresh Ubuntu/Debian server
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_USER="garudrecon"
APP_DIR="/home/$APP_USER/GarudRecon"
DOMAIN=""  # Will be prompted
USE_SSL=false

# Print colored message
print_message() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Print header
print_header() {
    echo ""
    echo "=========================================="
    echo "  $1"
    echo "=========================================="
    echo ""
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        print_message "$RED" "Please run as root (use sudo)"
        exit 1
    fi
}

# Get configuration from user
get_configuration() {
    print_header "Configuration"
    
    read -p "Enter your domain name (or press Enter for IP-only access): " DOMAIN
    
    if [ ! -z "$DOMAIN" ]; then
        read -p "Do you want to setup SSL with Let's Encrypt? (y/n): " ssl_choice
        if [ "$ssl_choice" = "y" ] || [ "$ssl_choice" = "Y" ]; then
            USE_SSL=true
        fi
    fi
    
    read -p "Install security tools? (y/n): " install_tools
}

# Update system
update_system() {
    print_header "Updating System"
    apt update && apt upgrade -y
    print_message "$GREEN" "✓ System updated"
}

# Install dependencies
install_dependencies() {
    print_header "Installing Dependencies"
    
    apt install -y \
        python3 \
        python3-pip \
        python3-venv \
        git \
        curl \
        wget \
        unzip \
        build-essential \
        nginx \
        supervisor \
        ufw \
        htop
    
    if [ "$USE_SSL" = true ]; then
        apt install -y certbot python3-certbot-nginx
    fi
    
    print_message "$GREEN" "✓ Dependencies installed"
}

# Create application user
create_user() {
    print_header "Creating Application User"
    
    if id "$APP_USER" &>/dev/null; then
        print_message "$YELLOW" "User $APP_USER already exists"
    else
        adduser --disabled-password --gecos "" $APP_USER
        usermod -aG sudo $APP_USER
        print_message "$GREEN" "✓ User $APP_USER created"
    fi
}

# Clone and setup application
setup_application() {
    print_header "Setting Up Application"
    
    # Switch to app user
    sudo -u $APP_USER bash << EOF
        cd /home/$APP_USER
        
        # Clone if not exists
        if [ ! -d "GarudRecon" ]; then
            git clone https://github.com/arjanchaudharyy/GarudRecon.git
        else
            cd GarudRecon
            git pull
            cd ..
        fi
        
        cd GarudRecon
        
        # Make scripts executable
        chmod +x garudrecon start_web.sh test_web.sh cmd/scan_*
        
        # Create virtual environment
        python3 -m venv venv
        source venv/bin/activate
        
        # Install Python dependencies
        pip install --upgrade pip
        pip install -r requirements.txt
        pip install gunicorn
        
        # Create necessary directories
        mkdir -p scans logs
        
        # Copy environment file
        if [ ! -f .env ]; then
            cp deployment/.env.example .env
            # Generate random secret key
            SECRET_KEY=\$(python3 -c 'import secrets; print(secrets.token_hex(32))')
            sed -i "s/change-this-to-a-random-secret-key-use-python-secrets-module/\$SECRET_KEY/" .env
        fi
EOF
    
    print_message "$GREEN" "✓ Application setup complete"
}

# Configure firewall
configure_firewall() {
    print_header "Configuring Firewall"
    
    ufw --force reset
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow 22/tcp
    ufw allow 80/tcp
    
    if [ "$USE_SSL" = true ]; then
        ufw allow 443/tcp
    fi
    
    ufw --force enable
    
    print_message "$GREEN" "✓ Firewall configured"
}

# Setup systemd service
setup_systemd() {
    print_header "Setting Up Systemd Service"
    
    # Update paths in service file
    cat > /etc/systemd/system/garudrecon.service << EOF
[Unit]
Description=GarudRecon Web Interface
After=network.target

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR
Environment="PATH=$APP_DIR/venv/bin"
Environment="FLASK_ENV=production"
ExecStart=$APP_DIR/venv/bin/gunicorn -c $APP_DIR/gunicorn_config.py web_backend:app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable garudrecon
    systemctl start garudrecon
    
    print_message "$GREEN" "✓ Systemd service configured and started"
}

# Setup Nginx
setup_nginx() {
    print_header "Setting Up Nginx"
    
    # Backup default config
    if [ -f /etc/nginx/sites-enabled/default ]; then
        mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.backup
    fi
    
    # Create nginx config
    if [ -z "$DOMAIN" ]; then
        SERVER_NAME="_"
    else
        SERVER_NAME="$DOMAIN www.$DOMAIN"
    fi
    
    cat > /etc/nginx/sites-available/garudrecon << EOF
server {
    listen 80;
    server_name $SERVER_NAME;

    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    access_log /var/log/nginx/garudrecon_access.log;
    error_log /var/log/nginx/garudrecon_error.log;

    client_max_body_size 100M;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
        send_timeout 600;
    }
}
EOF
    
    ln -sf /etc/nginx/sites-available/garudrecon /etc/nginx/sites-enabled/
    nginx -t
    systemctl restart nginx
    
    print_message "$GREEN" "✓ Nginx configured"
}

# Setup SSL
setup_ssl() {
    if [ "$USE_SSL" = true ] && [ ! -z "$DOMAIN" ]; then
        print_header "Setting Up SSL"
        
        certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --register-unsafely-without-email
        
        # Setup auto-renewal
        (crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet") | crontab -
        
        print_message "$GREEN" "✓ SSL configured"
    fi
}

# Install security tools
install_security_tools() {
    if [ "$install_tools" = "y" ] || [ "$install_tools" = "Y" ]; then
        print_header "Installing Security Tools"
        
        sudo -u $APP_USER bash << EOF
            cd $APP_DIR
            source venv/bin/activate
            ./garudrecon install -f ALL
EOF
        
        print_message "$GREEN" "✓ Security tools installed"
    fi
}

# Setup monitoring
setup_monitoring() {
    print_header "Setting Up Monitoring"
    
    # Log rotation
    cat > /etc/logrotate.d/garudrecon << EOF
$APP_DIR/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 $APP_USER $APP_USER
    sharedscripts
    postrotate
        systemctl reload garudrecon > /dev/null 2>&1 || true
    endscript
}
EOF
    
    # Cleanup script
    cat > /usr/local/bin/garudrecon-cleanup << 'EOF'
#!/bin/bash
SCAN_DIR="/home/garudrecon/GarudRecon/scans"
DAYS_TO_KEEP=30
find $SCAN_DIR -type d -mtime +$DAYS_TO_KEEP -exec rm -rf {} + 2>/dev/null
echo "Cleanup completed: $(date)"
EOF
    
    chmod +x /usr/local/bin/garudrecon-cleanup
    
    # Add to crontab
    (crontab -l 2>/dev/null; echo "0 3 * * 0 /usr/local/bin/garudrecon-cleanup >> /var/log/garudrecon_cleanup.log 2>&1") | crontab -
    
    print_message "$GREEN" "✓ Monitoring configured"
}

# Print success message
print_success() {
    print_header "Deployment Complete!"
    
    echo "GarudRecon has been successfully deployed!"
    echo ""
    echo "Access your installation:"
    if [ -z "$DOMAIN" ]; then
        echo "  → http://$(curl -s ifconfig.me)"
    else
        if [ "$USE_SSL" = true ]; then
            echo "  → https://$DOMAIN"
        else
            echo "  → http://$DOMAIN"
        fi
    fi
    echo ""
    echo "Useful commands:"
    echo "  Status:  sudo systemctl status garudrecon"
    echo "  Logs:    sudo journalctl -u garudrecon -f"
    echo "  Restart: sudo systemctl restart garudrecon"
    echo ""
    echo "Next steps:"
    echo "  1. Test the web interface"
    echo "  2. Run a Light scan"
    echo "  3. Review the documentation at /home/$APP_USER/GarudRecon"
    echo ""
    print_message "$GREEN" "Happy Scanning! 🚀"
}

# Main execution
main() {
    print_header "GarudRecon Web Interface - Automated Deployment"
    
    check_root
    get_configuration
    update_system
    install_dependencies
    create_user
    configure_firewall
    setup_application
    setup_systemd
    setup_nginx
    setup_ssl
    install_security_tools
    setup_monitoring
    print_success
}

# Run main
main
