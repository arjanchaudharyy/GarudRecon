# 🚀 GarudRecon Web Interface - Complete Deployment Guide

This guide covers everything from local testing to production deployment on VPS/Cloud servers.

## 📋 Table of Contents

1. [Local Development Deployment](#1-local-development-deployment)
2. [VPS/Cloud Server Deployment](#2-vpscloud-server-deployment)
3. [Docker Deployment](#3-docker-deployment)
4. [Production Setup with Nginx](#4-production-setup-with-nginx)
5. [Security Hardening](#5-security-hardening)
6. [Monitoring & Maintenance](#6-monitoring--maintenance)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Local Development Deployment

### Prerequisites
- Ubuntu 20.04+ / Kali Linux / Debian / macOS / WSL
- Python 3.7+
- Git

### Quick Local Setup

```bash
# 1. Clone the repository
git clone https://github.com/rix4uni/GarudRecon.git
cd GarudRecon

# 2. Make scripts executable
chmod +x garudrecon start_web.sh test_web.sh cmd/scan_*

# 3. Start the web interface
./start_web.sh

# 4. Access at http://localhost:5000
```

### Verify Installation

```bash
# Test the setup
./test_web.sh

# Check if server is running
curl http://localhost:5000/api/health
```

### Stop the Server

```bash
# Press Ctrl+C in the terminal where the server is running
# Or kill the process
lsof -ti:5000 | xargs kill -9
```

---

## 2. VPS/Cloud Server Deployment

### Step 1: Choose Your Provider

**Recommended Providers:**
- DigitalOcean (Droplet)
- Linode (Linode)
- AWS (EC2)
- Google Cloud (Compute Engine)
- Azure (Virtual Machine)
- Vultr

**Recommended Specs:**
```
Minimum:
- 2 GB RAM
- 2 CPU cores
- 20 GB storage
- Ubuntu 22.04 LTS

Recommended:
- 4 GB RAM
- 4 CPU cores
- 50 GB storage
- Ubuntu 22.04 LTS
```

### Step 2: Initial Server Setup

```bash
# SSH into your server
ssh root@your_server_ip

# Update system
apt update && apt upgrade -y

# Install required packages
apt install -y python3 python3-pip python3-venv git curl wget \
    build-essential nginx supervisor certbot python3-certbot-nginx

# Create a non-root user (recommended)
adduser garudrecon
usermod -aG sudo garudrecon

# Switch to new user
su - garudrecon
```

### Step 3: Install GarudRecon

```bash
# Clone repository
cd /home/garudrecon
git clone https://github.com/rix4uni/GarudRecon.git
cd GarudRecon

# Make scripts executable
chmod +x garudrecon start_web.sh cmd/scan_*

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Create necessary directories
mkdir -p scans logs
```

### Step 4: Install Security Tools (Optional)

```bash
# Install all reconnaissance tools
./garudrecon install -f ALL

# Or install specific sets
./garudrecon install -f SMALLSCOPE    # For Light scans
./garudrecon install -f MEDIUMSCOPE   # For Cool scans
./garudrecon install -f LARGESCOPE    # For Ultra scans
```

### Step 5: Configure Firewall

```bash
# Enable UFW firewall
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 5000/tcp    # GarudRecon (temporary)
sudo ufw enable
```

### Step 6: Test the Application

```bash
# Start the application
cd /home/garudrecon/GarudRecon
source venv/bin/activate
python3 web_backend.py

# Test from another terminal
curl http://your_server_ip:5000/api/health
```

---

## 3. Docker Deployment

### Option A: Using Docker Compose (Recommended)

```bash
# 1. Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 2. Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 3. Clone and deploy
git clone https://github.com/rix4uni/GarudRecon.git
cd GarudRecon

# 4. Build and run
docker-compose up -d

# 5. Check status
docker-compose ps

# 6. View logs
docker-compose logs -f

# 7. Access at http://your_server_ip:5000
```

### Option B: Using Docker Directly

```bash
# Build the image
docker build -t garudrecon-web .

# Run container
docker run -d \
    --name garudrecon \
    -p 5000:5000 \
    -v $(pwd)/scans:/app/scans \
    -v $(pwd)/configuration:/app/configuration \
    --restart unless-stopped \
    garudrecon-web

# Check logs
docker logs -f garudrecon

# Stop container
docker stop garudrecon

# Start container
docker start garudrecon
```

### Docker Management Commands

```bash
# View running containers
docker ps

# Stop and remove container
docker stop garudrecon && docker rm garudrecon

# Rebuild image
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Clean up old images
docker image prune -a
```

---

## 4. Production Setup with Nginx

### Step 1: Create Systemd Service

```bash
# Create service file
sudo nano /etc/systemd/system/garudrecon.service
```

Add this content:

```ini
[Unit]
Description=GarudRecon Web Interface
After=network.target

[Service]
Type=simple
User=garudrecon
Group=garudrecon
WorkingDirectory=/home/garudrecon/GarudRecon
Environment="PATH=/home/garudrecon/GarudRecon/venv/bin"
ExecStart=/home/garudrecon/GarudRecon/venv/bin/python3 /home/garudrecon/GarudRecon/web_backend.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable garudrecon
sudo systemctl start garudrecon
sudo systemctl status garudrecon
```

### Step 2: Configure Nginx as Reverse Proxy

```bash
# Create Nginx configuration
sudo nano /etc/nginx/sites-available/garudrecon
```

Add this content:

```nginx
server {
    listen 80;
    server_name your_domain.com;  # Replace with your domain

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Logs
    access_log /var/log/nginx/garudrecon_access.log;
    error_log /var/log/nginx/garudrecon_error.log;

    # Max upload size
    client_max_body_size 100M;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts for long-running scans
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
        send_timeout 600;
    }
}
```

Enable the site:

```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/garudrecon /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

### Step 3: Setup SSL with Let's Encrypt

```bash
# Install Certbot (if not already installed)
sudo apt install certbot python3-certbot-nginx -y

# Obtain SSL certificate
sudo certbot --nginx -d your_domain.com

# Test automatic renewal
sudo certbot renew --dry-run
```

After SSL setup, access at: **https://your_domain.com**

---

## 5. Security Hardening

### Update web_backend.py for Production

Create a production configuration file:

```bash
nano /home/garudrecon/GarudRecon/production_config.py
```

```python
# production_config.py
import os

class Config:
    # Security
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'change-this-to-random-string'
    
    # Flask
    DEBUG = False
    TESTING = False
    
    # CORS (restrict to your domain)
    CORS_ORIGINS = ['https://your_domain.com']
    
    # Rate limiting
    RATELIMIT_ENABLED = True
    RATELIMIT_DEFAULT = "100 per hour"
    
    # Scan limits
    MAX_CONCURRENT_SCANS = 5
    SCAN_TIMEOUT = 7200  # 2 hours
```

### Modify web_backend.py

```python
# At the top of web_backend.py, add:
from production_config import Config

app = Flask(__name__, static_folder='web', static_url_path='')
app.config.from_object(Config)

# Update CORS
CORS(app, origins=app.config['CORS_ORIGINS'])

# Change the final run to:
if __name__ == '__main__':
    # Production should use gunicorn or similar
    app.run(host='127.0.0.1', port=5000, debug=False)
```

### Install Gunicorn (Production WSGI Server)

```bash
source venv/bin/activate
pip install gunicorn

# Create gunicorn config
nano gunicorn_config.py
```

```python
# gunicorn_config.py
bind = "127.0.0.1:5000"
workers = 4
worker_class = "sync"
timeout = 600
keepalive = 5
accesslog = "logs/gunicorn_access.log"
errorlog = "logs/gunicorn_error.log"
loglevel = "info"
```

Update systemd service:

```bash
sudo nano /etc/systemd/system/garudrecon.service
```

Change ExecStart to:

```ini
ExecStart=/home/garudrecon/GarudRecon/venv/bin/gunicorn -c /home/garudrecon/GarudRecon/gunicorn_config.py web_backend:app
```

Restart:

```bash
sudo systemctl daemon-reload
sudo systemctl restart garudrecon
```

### Additional Security Measures

```bash
# 1. Create a .env file for sensitive data
nano /home/garudrecon/GarudRecon/.env
```

```bash
SECRET_KEY=your-super-secret-random-key-here
FLASK_ENV=production
```

```bash
# 2. Restrict file permissions
chmod 600 /home/garudrecon/GarudRecon/.env
chmod 755 /home/garudrecon/GarudRecon/scans

# 3. Setup log rotation
sudo nano /etc/logrotate.d/garudrecon
```

```
/home/garudrecon/GarudRecon/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 garudrecon garudrecon
}
```

---

## 6. Monitoring & Maintenance

### Setup Monitoring with Supervisor

```bash
sudo apt install supervisor -y

# Create supervisor config
sudo nano /etc/supervisor/conf.d/garudrecon.conf
```

```ini
[program:garudrecon]
directory=/home/garudrecon/GarudRecon
command=/home/garudrecon/GarudRecon/venv/bin/gunicorn -c gunicorn_config.py web_backend:app
user=garudrecon
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
stderr_logfile=/var/log/garudrecon/err.log
stdout_logfile=/var/log/garudrecon/out.log
```

```bash
# Create log directory
sudo mkdir -p /var/log/garudrecon
sudo chown garudrecon:garudrecon /var/log/garudrecon

# Update supervisor
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status garudrecon
```

### Monitoring Commands

```bash
# Check application status
sudo systemctl status garudrecon

# View logs
sudo journalctl -u garudrecon -f

# Check Nginx logs
sudo tail -f /var/log/nginx/garudrecon_access.log
sudo tail -f /var/log/nginx/garudrecon_error.log

# Check disk usage
df -h
du -sh /home/garudrecon/GarudRecon/scans

# Monitor system resources
htop
```

### Automated Backups

```bash
# Create backup script
nano /home/garudrecon/backup_garudrecon.sh
```

```bash
#!/bin/bash

BACKUP_DIR="/home/garudrecon/backups"
DATE=$(date +%Y%m%d_%H%M%S)
SCAN_DIR="/home/garudrecon/GarudRecon/scans"

mkdir -p $BACKUP_DIR

# Backup scans
tar czf $BACKUP_DIR/scans_$DATE.tar.gz $SCAN_DIR

# Keep only last 7 days of backups
find $BACKUP_DIR -name "scans_*.tar.gz" -mtime +7 -delete

echo "Backup completed: scans_$DATE.tar.gz"
```

```bash
chmod +x /home/garudrecon/backup_garudrecon.sh

# Add to crontab
crontab -e
```

Add:
```
# Daily backup at 2 AM
0 2 * * * /home/garudrecon/backup_garudrecon.sh >> /home/garudrecon/backup.log 2>&1
```

### Cleanup Old Scans

```bash
# Create cleanup script
nano /home/garudrecon/cleanup_scans.sh
```

```bash
#!/bin/bash

SCAN_DIR="/home/garudrecon/GarudRecon/scans"
DAYS_TO_KEEP=30

# Delete scans older than 30 days
find $SCAN_DIR -type d -mtime +$DAYS_TO_KEEP -exec rm -rf {} + 2>/dev/null

echo "Cleanup completed: Removed scans older than $DAYS_TO_KEEP days"
```

```bash
chmod +x /home/garudrecon/cleanup_scans.sh

# Add to crontab (weekly cleanup)
crontab -e
```

Add:
```
# Weekly cleanup on Sunday at 3 AM
0 3 * * 0 /home/garudrecon/cleanup_scans.sh >> /home/garudrecon/cleanup.log 2>&1
```

---

## 7. Troubleshooting

### Common Issues and Solutions

#### Issue 1: Port 5000 Already in Use

```bash
# Find process using port 5000
sudo lsof -i :5000

# Kill the process
sudo kill -9 $(lsof -ti:5000)

# Or change port in web_backend.py
nano web_backend.py
# Change: app.run(host='0.0.0.0', port=5000)
# To: app.run(host='0.0.0.0', port=8080)
```

#### Issue 2: Permission Denied

```bash
# Fix ownership
sudo chown -R garudrecon:garudrecon /home/garudrecon/GarudRecon

# Fix permissions
chmod +x garudrecon start_web.sh cmd/scan_*
chmod 755 /home/garudrecon/GarudRecon/scans
```

#### Issue 3: Module Not Found

```bash
# Ensure virtual environment is activated
source venv/bin/activate

# Reinstall dependencies
pip install --upgrade pip
pip install -r requirements.txt
```

#### Issue 4: Nginx 502 Bad Gateway

```bash
# Check if application is running
sudo systemctl status garudrecon

# Check application logs
sudo journalctl -u garudrecon -n 50

# Restart services
sudo systemctl restart garudrecon
sudo systemctl restart nginx
```

#### Issue 5: SSL Certificate Issues

```bash
# Renew certificate manually
sudo certbot renew

# Check certificate status
sudo certbot certificates

# Force renewal
sudo certbot renew --force-renewal
```

#### Issue 6: Scans Not Starting

```bash
# Check if scan scripts are executable
ls -la cmd/scan_*

# Make executable
chmod +x cmd/scan_*

# Check logs
tail -f logs/gunicorn_error.log

# Test scan manually
./cmd/scan_light -d example.com -o test-output/
```

### Performance Tuning

#### For Better Performance

```bash
# Increase worker processes (gunicorn_config.py)
workers = (2 * CPU_CORES) + 1

# Adjust timeouts
timeout = 1200  # 20 minutes

# Use worker class
worker_class = "gevent"  # Install: pip install gevent
```

#### Monitor Resource Usage

```bash
# Real-time monitoring
htop

# Disk usage
df -h
du -sh /home/garudrecon/GarudRecon/*

# Memory usage
free -h

# Process monitoring
ps aux | grep gunicorn
```

---

## 📊 Deployment Checklist

### Pre-Deployment
- [ ] Server meets minimum requirements
- [ ] Domain name configured (if using)
- [ ] SSH access configured
- [ ] Firewall rules planned

### Installation
- [ ] System updated
- [ ] Python 3.7+ installed
- [ ] GarudRecon cloned
- [ ] Dependencies installed
- [ ] Scripts made executable

### Configuration
- [ ] Virtual environment created
- [ ] Configuration files updated
- [ ] Environment variables set
- [ ] Secrets configured

### Security
- [ ] Firewall enabled
- [ ] SSL certificate installed
- [ ] Security headers configured
- [ ] File permissions set
- [ ] Non-root user created

### Production Setup
- [ ] Systemd service created
- [ ] Nginx configured
- [ ] Gunicorn installed
- [ ] Supervisor configured (optional)

### Testing
- [ ] Application starts successfully
- [ ] Health endpoint responds
- [ ] Can create and view scans
- [ ] SSL works correctly
- [ ] Logs are being written

### Monitoring
- [ ] Log rotation configured
- [ ] Backup script created
- [ ] Cleanup script created
- [ ] Monitoring tools configured

### Post-Deployment
- [ ] Test all scan modes
- [ ] Verify email notifications (if configured)
- [ ] Test backup restoration
- [ ] Document any custom changes

---

## 🎯 Quick Deployment Summary

### For Development (Local)
```bash
git clone https://github.com/rix4uni/GarudRecon.git
cd GarudRecon
./start_web.sh
```

### For Production (VPS)
```bash
# On server
git clone https://github.com/rix4uni/GarudRecon.git
cd GarudRecon
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt gunicorn
# Configure systemd service
# Configure Nginx
# Setup SSL
sudo systemctl start garudrecon
```

### For Docker
```bash
git clone https://github.com/rix4uni/GarudRecon.git
cd GarudRecon
docker-compose up -d
```

---

## 📞 Support

If you encounter issues:
1. Check the [Troubleshooting](#7-troubleshooting) section
2. Review logs: `sudo journalctl -u garudrecon -f`
3. Test manually: `./test_web.sh`
4. Check GitHub issues
5. Review documentation: [WEB_INTERFACE.md](WEB_INTERFACE.md)

---

## 🎉 Congratulations!

Your GarudRecon web interface is now deployed!

**Access your deployment:**
- Development: http://localhost:5000
- Production: https://your_domain.com

**Next Steps:**
1. Install security tools: `./garudrecon install -f ALL`
2. Try a Light scan to verify functionality
3. Review the [QUICKSTART.md](QUICKSTART.md) guide
4. Set up monitoring and backups

---

Made with ❤️ for Security Researchers
