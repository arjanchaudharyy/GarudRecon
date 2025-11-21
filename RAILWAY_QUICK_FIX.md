# Railway Deployment - Quick Fix Guide

## 🚨 Problem: Scans Show 0 Results

### Symptoms
```
DNS Records Found: 0
Subdomains Found: 0
Open Ports Found: 0
Live URLs Found: 0
Vulnerabilities Found: 0
```

### Root Cause
**The reconnaissance tools are NOT installed in your Railway container.**

GarudRecon is just a framework - it needs external security tools to actually perform scans.

### ✅ Solution

Your repository includes a **Dockerfile** that pre-installs all tools. Follow these steps:

#### Step 1: Verify Your Dockerfile

Make sure your `Dockerfile` includes the tool installation section:

```dockerfile
# Install Go-based reconnaissance tools
RUN mkdir -p $GOPATH/bin && \
    echo "Installing httpx..." && \
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    echo "Installing subfinder..." && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    # ... more tools
```

#### Step 2: Redeploy on Railway

1. Go to Railway Dashboard → Your Project
2. Click the three dots (⋮) menu
3. Select **"Redeploy"**
4. Wait 5-10 minutes for build to complete
5. Check build logs for tool installation confirmation

#### Step 3: Verify Tool Installation

Check Railway logs after deployment. You should see:

```
=== Verifying tool installation ===
System tools:
/usr/bin/dig
/usr/bin/nmap
...
Go tools:
/root/go/bin/httpx
/root/go/bin/subfinder
/root/go/bin/nuclei
...
===================================

✅ All essential tools are installed!
✓ Found: dig, nmap, curl, httpx, subfinder, nuclei
```

#### Step 4: Test with API

```bash
# Check tool availability
curl https://your-app.railway.app/api/tools

# Should return:
{
  "available_tools": {
    "light": ["dig", "curl"],
    "cool": ["subfinder", "httpx", "dnsx"],
    "ultra": ["subfinder", "httpx", "nuclei", "naabu"]
  }
}
```

## 🔧 Alternative Solutions

### If Redeploy Doesn't Work

1. **Check Build Logs**
   - Railway Dashboard → Deployments → View Build Logs
   - Look for `go install` errors
   - Check if build timed out

2. **Verify Dockerfile Path**
   - Ensure `railway.toml` points to correct Dockerfile:
   ```toml
   [build]
   builder = "DOCKERFILE"
   dockerfilePath = "Dockerfile"
   ```

3. **Check Branch**
   - Make sure Railway is deploying from correct branch
   - Verify Dockerfile is in root of repository

### If Build Times Out

The full tool installation can take 5-10 minutes. If Railway times out:

**Option A: Remove Non-Essential Tools**

Edit `Dockerfile` and remove tools you don't need:
```dockerfile
# Keep only essential tools
RUN go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```

**Option B: Deploy During Off-Peak Hours**

Railway build times can vary. Try deploying during less busy times.

**Option C: Use Railway Pro**

Pro tier has higher build time limits.

## 📊 Expected Results After Fix

Once tools are installed, scans should show real results:

### Light Scan (5-10 minutes)
```json
{
  "dns_records": 15,
  "ports_found": 5,
  "urls_crawled": 120,
  "xss_findings": 2,
  "sql_tests": 10
}
```

### Cool Scan (20-30 minutes)
```json
{
  "subdomains": 45,
  "live_hosts": 32,
  "open_ports": 78,
  "vulnerabilities": 12
}
```

### Ultra Scan (1-2 hours)
```json
{
  "total_subdomains": 150,
  "live_subdomains": 89,
  "total_ports": 245,
  "vulnerabilities": 34
}
```

## 🎯 Quick Test After Deployment

1. **Access Web Interface**
   ```
   https://your-app.railway.app
   ```

2. **Run Test Scan**
   - Enter: `example.com` (or a domain you own)
   - Select: Light scan
   - Wait: 5-10 minutes

3. **Check Results**
   - Should show actual numbers (not all 0s)
   - View detailed JSON results
   - Download results file

## ⚡ One-Line Fix Summary

```bash
# The fix is already in your Dockerfile!
# Just redeploy on Railway:
# Dashboard → Project → ⋮ → Redeploy → Wait 5-10 mins
```

## 🔍 Debugging Commands

If you have Railway CLI installed:

```bash
# Check logs
railway logs

# SSH into container
railway run bash

# Verify tools manually
railway run bash -c "which httpx subfinder nuclei"

# Test scan manually
railway run bash -c "./cmd/scan_light -d example.com -o /tmp/test"
```

## 📞 Still Having Issues?

1. **Check Railway Build Logs** - Most issues show up here
2. **Verify Environment Variables** - Make sure PORT is set correctly
3. **Check Repository** - Ensure Dockerfile is in root and up-to-date
4. **Review Railway Status** - Check https://railway.app/status for platform issues

## 💡 Prevention

To avoid this in future:

1. Always test Dockerfile locally first:
   ```bash
   docker build -t garudrecon .
   docker run -p 5000:5000 garudrecon
   ```

2. Keep Dockerfile updated with latest tool versions

3. Monitor Railway build logs for any installation failures

4. Set up health check alerts in Railway dashboard

---

**Remember:** GarudRecon is a framework that orchestrates external tools. Without the tools, it's like having a car without an engine - it looks good but doesn't go anywhere! 🚗💨
