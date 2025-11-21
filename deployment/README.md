# GarudRecon Deployment Files

This directory contains all necessary files and scripts for deploying GarudRecon Web Interface.

## 📁 Files Overview

### Automated Deployment Scripts
- **`deploy.sh`** - Full automated deployment on VPS/Cloud (Ubuntu/Debian)
- **`deploy-docker.sh`** - Quick Docker deployment script

### Configuration Templates
- **`garudrecon.service`** - Systemd service file
- **`nginx.conf`** - Nginx reverse proxy configuration
- **`supervisor.conf`** - Supervisor process manager configuration
- **`.env.example`** - Environment variables template

### Configuration Files (Auto-generated)
- **`gunicorn_config.py`** - Gunicorn WSGI server configuration (in root directory)
- **`production_config.py`** - Production Flask configuration (in root directory)

---

## 🚀 Quick Deployment Options

### Option 1: Automated Full Deployment (Recommended for VPS)

Deploy everything automatically on a fresh Ubuntu/Debian server:

```bash
# Download and run the deployment script
curl -fsSL https://raw.githubusercontent.com/arjanchaudharyy/GarudRecon/main/deployment/deploy.sh -o deploy.sh
chmod +x deploy.sh
sudo ./deploy.sh
```

This script will:
- ✅ Update system
- ✅ Install all dependencies
- ✅ Create application user
- ✅ Setup firewall
- ✅ Configure Nginx
- ✅ Setup SSL (optional)
- ✅ Create systemd service
- ✅ Install security tools (optional)
- ✅ Configure monitoring

### Option 2: Docker Deployment (Easiest)

Quick deployment using Docker:

```bash
# Download and run
curl -fsSL https://raw.githubusercontent.com/arjanchaudharyy/GarudRecon/main/deployment/deploy-docker.sh -o deploy-docker.sh
chmod +x deploy-docker.sh
./deploy-docker.sh
```

### Option 3: Manual Deployment

Follow the comprehensive guide in [DEPLOYMENT.md](../DEPLOYMENT.md)

---

## 📋 Manual Setup Instructions

### 1. Systemd Service

```bash
# Copy service file
sudo cp garudrecon.service /etc/systemd/system/

# Update paths if needed
sudo nano /etc/systemd/system/garudrecon.service

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable garudrecon
sudo systemctl start garudrecon
sudo systemctl status garudrecon
```

### 2. Nginx Configuration

```bash
# Copy nginx config
sudo cp nginx.conf /etc/nginx/sites-available/garudrecon

# Update domain name
sudo nano /etc/nginx/sites-available/garudrecon

# Enable site
sudo ln -s /etc/nginx/sites-available/garudrecon /etc/nginx/sites-enabled/

# Test and reload
sudo nginx -t
sudo systemctl reload nginx
```

### 3. SSL Setup

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d yourdomain.com

# Auto-renewal (already done by certbot)
sudo certbot renew --dry-run
```

### 4. Environment Variables

```bash
# Copy example file
cp .env.example ../.env

# Edit with your values
nano ../.env

# Generate secret key
python3 -c 'import secrets; print(secrets.token_hex(32))'
```

### 5. Supervisor (Alternative to Systemd)

```bash
# Install supervisor
sudo apt install supervisor

# Create log directory
sudo mkdir -p /var/log/garudrecon
sudo chown garudrecon:garudrecon /var/log/garudrecon

# Copy config
sudo cp supervisor.conf /etc/supervisor/conf.d/garudrecon.conf

# Update and start
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start garudrecon
```

---

## 🔧 Configuration Details

### Systemd Service

The service file configures:
- Service runs as dedicated user `garudrecon`
- Auto-restart on failure
- Working directory and environment
- Security restrictions

**Managing the service:**
```bash
sudo systemctl start garudrecon
sudo systemctl stop garudrecon
sudo systemctl restart garudrecon
sudo systemctl status garudrecon
sudo journalctl -u garudrecon -f
```

### Nginx Configuration

The nginx config provides:
- Reverse proxy to Flask application
- Security headers
- Long timeouts for scans
- SSL configuration (when enabled)
- Static file caching

**Managing Nginx:**
```bash
sudo nginx -t                    # Test configuration
sudo systemctl reload nginx      # Reload config
sudo systemctl restart nginx     # Full restart
sudo tail -f /var/log/nginx/garudrecon_access.log
```

### Gunicorn Configuration

Located in root directory: `gunicorn_config.py`

Key settings:
- Bind address: 127.0.0.1:5000
- Workers: CPU cores * 2 + 1
- Timeout: 600 seconds (for long scans)
- Logging configuration

**Testing Gunicorn directly:**
```bash
cd /path/to/GarudRecon
source venv/bin/activate
gunicorn -c gunicorn_config.py web_backend:app
```

### Production Configuration

Located in root directory: `production_config.py`

Contains:
- Security settings
- CORS configuration
- Scan limits
- Logging settings

**Using different configs:**
```bash
# Development
export FLASK_ENV=development

# Production
export FLASK_ENV=production

# Docker
export FLASK_ENV=docker
```

---

## 🐳 Docker Deployment Details

### Using Docker Compose

```bash
# Start
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose stop

# Restart
docker-compose restart

# Shutdown and remove
docker-compose down

# Rebuild
docker-compose build --no-cache
docker-compose up -d
```

### Using Docker Directly

```bash
# Build
docker build -t garudrecon-web .

# Run
docker run -d \
  --name garudrecon \
  -p 5000:5000 \
  -v $(pwd)/scans:/app/scans \
  -v $(pwd)/configuration:/app/configuration \
  --restart unless-stopped \
  garudrecon-web

# Manage
docker ps
docker logs -f garudrecon
docker stop garudrecon
docker start garudrecon
docker restart garudrecon
```

---

## 🔒 Security Checklist

Before going to production:

- [ ] Change default secret key
- [ ] Configure CORS with your domain
- [ ] Setup SSL certificate
- [ ] Configure firewall rules
- [ ] Use non-root user
- [ ] Set file permissions correctly
- [ ] Enable log rotation
- [ ] Setup automatic backups
- [ ] Configure monitoring
- [ ] Test auto-restart functionality
- [ ] Review Nginx security headers
- [ ] Setup rate limiting (if needed)

---

## 📊 Monitoring

### System Logs

```bash
# Application logs
sudo journalctl -u garudrecon -f

# Nginx access logs
sudo tail -f /var/log/nginx/garudrecon_access.log

# Nginx error logs
sudo tail -f /var/log/nginx/garudrecon_error.log

# Gunicorn logs
tail -f logs/gunicorn_access.log
tail -f logs/gunicorn_error.log
```

### System Resources

```bash
# CPU and Memory
htop

# Disk usage
df -h
du -sh /home/garudrecon/GarudRecon/scans

# Process info
ps aux | grep gunicorn

# Network connections
netstat -tulpn | grep 5000
```

### Health Checks

```bash
# API health check
curl http://localhost:5000/api/health

# Full check
curl -I http://localhost:5000

# With domain
curl https://yourdomain.com/api/health
```

---

## 🔄 Updates and Maintenance

### Updating GarudRecon

```bash
cd /home/garudrecon/GarudRecon
git pull
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart garudrecon
```

### Cleaning Old Scans

```bash
# Manual cleanup (older than 30 days)
find /home/garudrecon/GarudRecon/scans -type d -mtime +30 -exec rm -rf {} +

# Automated cleanup is configured via cron
```

### Backup

```bash
# Backup scans
tar czf scans-backup-$(date +%Y%m%d).tar.gz scans/

# Backup configuration
tar czf config-backup-$(date +%Y%m%d).tar.gz configuration/ .env
```

---

## 🆘 Troubleshooting

### Service Won't Start

```bash
# Check status
sudo systemctl status garudrecon

# Check logs
sudo journalctl -u garudrecon -n 50 --no-pager

# Test manually
cd /home/garudrecon/GarudRecon
source venv/bin/activate
python3 web_backend.py
```

### Nginx 502 Bad Gateway

```bash
# Check if app is running
sudo systemctl status garudrecon

# Check port binding
sudo netstat -tulpn | grep 5000

# Check nginx error log
sudo tail -f /var/log/nginx/garudrecon_error.log
```

### Permission Errors

```bash
# Fix ownership
sudo chown -R garudrecon:garudrecon /home/garudrecon/GarudRecon

# Fix permissions
chmod +x /home/garudrecon/GarudRecon/garudrecon
chmod +x /home/garudrecon/GarudRecon/cmd/scan_*
chmod 755 /home/garudrecon/GarudRecon/scans
```

### SSL Issues

```bash
# Test SSL
sudo certbot certificates

# Renew manually
sudo certbot renew

# Check auto-renewal
sudo certbot renew --dry-run
```

---

## 📞 Support

For more information:
- Main Documentation: [../README.md](../README.md)
- Deployment Guide: [../DEPLOYMENT.md](../DEPLOYMENT.md)
- Quick Start: [../QUICKSTART.md](../QUICKSTART.md)
- Web Interface: [../WEB_INTERFACE.md](../WEB_INTERFACE.md)

---

## 🎯 Quick Reference

| Task | Command |
|------|---------|
| Start service | `sudo systemctl start garudrecon` |
| Stop service | `sudo systemctl stop garudrecon` |
| Restart service | `sudo systemctl restart garudrecon` |
| View logs | `sudo journalctl -u garudrecon -f` |
| Test nginx | `sudo nginx -t` |
| Reload nginx | `sudo systemctl reload nginx` |
| Health check | `curl localhost:5000/api/health` |
| Docker logs | `docker-compose logs -f` |
| Update app | `git pull && pip install -r requirements.txt` |

---

Made with ❤️ for Security Researchers
