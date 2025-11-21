# 📋 GarudRecon Deployment Checklist

Use this checklist to ensure successful deployment.

---

## Pre-Deployment Checklist

### Planning
- [ ] Choose deployment environment (Local/VPS/Docker)
- [ ] Select deployment method (Automated/Manual/Docker)
- [ ] Determine if domain name is needed
- [ ] Decide on SSL requirement
- [ ] Plan resource allocation (RAM, CPU, storage)
- [ ] Identify which scan modes to use (Light/Cool/Ultra)

### Infrastructure (for VPS/Cloud)
- [ ] Server provisioned
- [ ] SSH access configured
- [ ] Root or sudo access available
- [ ] Domain DNS configured (if using domain)
- [ ] Firewall ports identified (22, 80, 443, 5000)

### Local Requirements
- [ ] Python 3.7+ installed
- [ ] Git installed (optional but recommended)
- [ ] Sufficient disk space (10GB+ recommended)
- [ ] Port 5000 available

---

## Deployment Checklist

### Option 1: Automated VPS Deployment

- [ ] **Download script**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/arjanchaudharyy/GarudRecon/main/deployment/deploy.sh -o deploy.sh
  chmod +x deploy.sh
  ```

- [ ] **Run deployment**
  ```bash
  sudo ./deploy.sh
  ```

- [ ] **Configure during prompts:**
  - [ ] Enter domain name (or skip)
  - [ ] Choose SSL setup (y/n)
  - [ ] Choose to install tools (y/n)

- [ ] **Wait for completion** (~5-10 minutes)

- [ ] **Verify deployment**
  ```bash
  sudo systemctl status garudrecon
  curl http://localhost:5000/api/health
  ```

### Option 2: Docker Deployment

- [ ] **Install Docker** (if not present)
  ```bash
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  ```

- [ ] **Install Docker Compose** (if not present)
  ```bash
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  ```

- [ ] **Clone repository**
  ```bash
  git clone https://github.com/arjanchaudharyy/GarudRecon.git
  cd GarudRecon
  ```

- [ ] **Start with Docker Compose**
  ```bash
  docker-compose up -d
  ```

- [ ] **Verify containers**
  ```bash
  docker-compose ps
  docker-compose logs
  curl http://localhost:5000/api/health
  ```

### Option 3: Manual Local Deployment

- [ ] **Clone repository**
  ```bash
  git clone https://github.com/arjanchaudharyy/GarudRecon.git
  cd GarudRecon
  ```

- [ ] **Make scripts executable**
  ```bash
  chmod +x garudrecon start_web.sh test_web.sh cmd/scan_*
  ```

- [ ] **Create virtual environment**
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  ```

- [ ] **Install dependencies**
  ```bash
  pip install --upgrade pip
  pip install -r requirements.txt
  ```

- [ ] **Start application**
  ```bash
  ./start_web.sh
  ```

- [ ] **Verify in browser**
  - Open http://localhost:5000

---

## Post-Deployment Checklist

### Verification
- [ ] **Run verification script**
  ```bash
  cd GarudRecon
  ./deployment/verify-deployment.sh
  ```

- [ ] **Test web interface**
  - [ ] Open in browser
  - [ ] Interface loads correctly
  - [ ] All three scan modes visible

- [ ] **Test API endpoints**
  ```bash
  curl http://localhost:5000/api/health
  curl http://localhost:5000/api/scans
  ```

- [ ] **Test scan functionality**
  - [ ] Start a Light scan
  - [ ] Monitor progress
  - [ ] View results
  - [ ] Download results

### Configuration (Production Only)

- [ ] **Environment variables**
  - [ ] Copy .env.example to .env
  - [ ] Generate and set SECRET_KEY
  - [ ] Configure CORS_ORIGINS
  - [ ] Set appropriate LOG_LEVEL

- [ ] **Security**
  - [ ] Change default secret key
  - [ ] Configure firewall rules
  - [ ] Restrict file permissions
  - [ ] Review security headers

- [ ] **SSL/TLS**
  - [ ] Domain configured in DNS
  - [ ] SSL certificate installed
  - [ ] HTTPS redirect enabled
  - [ ] Certificate auto-renewal tested

- [ ] **Service Management**
  - [ ] Systemd service enabled
  - [ ] Auto-restart configured
  - [ ] Service starts on boot

### Optimization

- [ ] **Performance**
  - [ ] Gunicorn workers configured (CPU cores * 2 + 1)
  - [ ] Timeout settings adjusted for scan duration
  - [ ] Log levels appropriate

- [ ] **Storage**
  - [ ] Scans directory created
  - [ ] Logs directory created
  - [ ] Sufficient disk space available
  - [ ] Backup strategy planned

- [ ] **Monitoring**
  - [ ] Log rotation configured
  - [ ] Cleanup script scheduled
  - [ ] Backup script scheduled (if needed)

---

## Security Checklist

### Essential Security
- [ ] Firewall enabled
- [ ] Only necessary ports open (22, 80, 443)
- [ ] Strong passwords used
- [ ] SSH key authentication (recommended)
- [ ] Root login disabled (recommended)

### Application Security
- [ ] SECRET_KEY changed from default
- [ ] CORS configured properly
- [ ] File permissions set correctly
- [ ] .env file protected (chmod 600)
- [ ] No sensitive data in version control

### Network Security
- [ ] SSL/TLS enabled (production)
- [ ] Security headers configured
- [ ] Rate limiting considered
- [ ] DDoS protection considered (if public-facing)

### Access Control
- [ ] Dedicated user account created
- [ ] Sudo access limited
- [ ] Application runs as non-root user

---

## Operational Checklist

### Daily Operations
- [ ] Monitor application logs
- [ ] Check disk usage
- [ ] Review scan results
- [ ] Check for errors

### Weekly Maintenance
- [ ] Review log files
- [ ] Clean up old scans
- [ ] Check SSL certificate expiry
- [ ] Update security tools (if installed)

### Monthly Tasks
- [ ] System updates
  ```bash
  sudo apt update && sudo apt upgrade
  ```
- [ ] Application updates
  ```bash
  git pull
  pip install -r requirements.txt
  sudo systemctl restart garudrecon
  ```
- [ ] Review security advisories
- [ ] Test backup restoration
- [ ] Review and optimize performance

---

## Troubleshooting Checklist

### If Application Won't Start

- [ ] Check service status
  ```bash
  sudo systemctl status garudrecon
  ```

- [ ] Check logs
  ```bash
  sudo journalctl -u garudrecon -n 50
  ```

- [ ] Verify Python dependencies
  ```bash
  pip list | grep -i flask
  ```

- [ ] Check port availability
  ```bash
  sudo lsof -i :5000
  ```

- [ ] Test manual start
  ```bash
  source venv/bin/activate
  python3 web_backend.py
  ```

### If Web Interface Not Accessible

- [ ] Check if application is running
- [ ] Verify firewall rules
- [ ] Check Nginx configuration (if using)
- [ ] Test locally first
  ```bash
  curl http://localhost:5000
  ```
- [ ] Check browser console for errors

### If Scans Fail

- [ ] Check scan script permissions
  ```bash
  ls -la cmd/scan_*
  ```

- [ ] Verify scan directories exist
  ```bash
  ls -la scans/
  ```

- [ ] Check available disk space
  ```bash
  df -h
  ```

- [ ] Review scan logs
  ```bash
  tail -f scans/*/summary.txt
  ```

- [ ] Test scan manually
  ```bash
  ./cmd/scan_light -d example.com -o test-output/
  ```

---

## Documentation Reference

- [ ] Read [QUICKSTART.md](../QUICKSTART.md)
- [ ] Review [DEPLOYMENT.md](../DEPLOYMENT.md)
- [ ] Check [WEB_INTERFACE.md](../WEB_INTERFACE.md)
- [ ] Browse [EXAMPLES.md](../EXAMPLES.md)
- [ ] Understand [FEATURES.md](../FEATURES.md)

---

## Success Criteria

Your deployment is successful when:

✅ Web interface is accessible  
✅ All three scan modes work  
✅ Scans complete successfully  
✅ Results are displayed correctly  
✅ Results can be downloaded  
✅ Service auto-restarts on failure  
✅ Logs are being written  
✅ SSL is working (if configured)  
✅ No errors in logs  
✅ Performance is acceptable  

---

## Final Steps

- [ ] **Document your deployment**
  - Note any custom configurations
  - Document server details
  - Save credentials securely

- [ ] **Train users** (if applicable)
  - Show how to use web interface
  - Explain scan types
  - Demonstrate result interpretation

- [ ] **Set up notifications** (optional)
  - Configure alerts for failures
  - Set up monitoring dashboards

- [ ] **Plan for scaling** (if needed)
  - Consider load balancing
  - Plan for multiple instances
  - Prepare for increased usage

---

## 🎉 Completion

Once all items are checked:

**Your GarudRecon deployment is complete and ready for use!**

Access your deployment and start scanning:
- Local: http://localhost:5000
- VPS: http://your-server-ip or https://your-domain.com

**Happy Scanning! 🚀**

---

For issues or questions, refer to:
- [DEPLOYMENT.md](../DEPLOYMENT.md) - Full deployment guide
- [Troubleshooting section](#troubleshooting-checklist) - Common issues
- GitHub Issues - Community support
