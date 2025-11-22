# Railway Quick Start Guide

## 🚀 Fast Deployment (2-3 minutes)

### Step 1: Deploy to Railway
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

Or manually:
1. Go to [railway.app](https://railway.app)
2. Click "New Project" → "Deploy from GitHub repo"
3. Select this repository
4. Railway will automatically detect the Dockerfile and deploy

### Step 2: Wait for Build (2-3 minutes)
Railway will:
- Build the Docker image (~2-3 minutes)
- Install all reconnaissance tools automatically
- Start the web server
- Assign you a public URL

### Step 3: Access Your Instance
Once deployed, Railway will show you a URL like:
```
https://your-app.railway.app
```

Visit this URL to access the GarudRecon web interface.

### Step 4: Verify Tools Are Installed
Visit:
```
https://your-app.railway.app/api/tools
```

You should see:
```json
{
  "status": "ok",
  "available_tools": {
    "httpx": true,
    "subfinder": true,
    "naabu": true,
    "nuclei": true,
    "dnsx": true,
    "katana": true,
    "waybackurls": true,
    "gau": true,
    "assetfinder": true,
    "anew": true,
    "dig": true,
    "nmap": true,
    "sqlmap": true
  },
  "message": "All essential tools are available"
}
```

### Step 5: Run Your First Scan
1. Go to your Railway URL
2. Enter a target domain (e.g., `example.com`)
3. Choose scan type:
   - **Light**: 5-10 minutes, basic reconnaissance
   - **Cool**: 20-30 minutes, includes subdomains
   - **Ultra**: 1-2 hours, comprehensive scan
4. Click "Start Scan"
5. Watch real-time progress

## 🔧 Troubleshooting

### Build Takes Too Long (>5 minutes)
**Solution**: Check Railway build logs. With the latest Dockerfile, build should complete in 2-3 minutes.
- If it's taking longer, Railway may be experiencing issues
- Try canceling and redeploying

### Build Times Out
**Solution**: This is now fixed! The Dockerfile uses pre-built binaries instead of compiling from source.
- Previous build time: 8-12 minutes (often timed out)
- Current build time: 2-3 minutes (well within limits)
- See: `RAILWAY_BUILD_TIMEOUT_FIX.md`

### Scans Show 0 Results
**Possible causes**:
1. **Tools not installed**: Check `/api/tools` endpoint
   - If tools are missing, redeploy: Dashboard → ⋮ → Redeploy
2. **Invalid domain**: Make sure you entered just the domain name
   - ✅ Good: `example.com`
   - ❌ Bad: `https://example.com/`, `www.example.com/page`
3. **Domain doesn't exist**: Try a known domain like `google.com`

### App Won't Start
**Check**:
1. Railway logs: Dashboard → Logs
2. Look for errors in the startup process
3. Verify `PORT` environment variable is set (Railway does this automatically)
4. Health check should pass at `/api/health`

## 📊 Expected Build Timeline

```
[0:00 - 0:30]  📦 Installing system packages (apt-get)
[0:30 - 1:00]  🔧 Installing Go compiler
[1:00 - 1:30]  ⚡ Downloading pre-built binaries (6 tools)
[1:30 - 2:00]  🔨 Compiling lightweight tools (4 tools)
[2:00 - 2:30]  🐍 Installing Python dependencies
[2:30 - 3:00]  ✅ Verification and cleanup

✓ Total: ~2-3 minutes
```

## 🎯 What's Different from Local Setup?

| Feature | Local | Railway (Docker) |
|---------|-------|------------------|
| Tool installation | Manual (`./install_basic_tools.sh`) | Automatic (in Dockerfile) |
| Installation time | 10-15 minutes | Pre-installed (build time: 2-3 min) |
| Port | 5000 | Auto-assigned by Railway |
| Access | `localhost:5000` | Public URL provided by Railway |
| Updates | `git pull` + reinstall | Redeploy on Railway |

## 🔄 How to Update

When new code is pushed to the repository:
1. Railway automatically detects changes
2. Rebuilds the Docker image
3. Redeploys with new code
4. Zero downtime (old version runs until new version is ready)

Manual redeploy:
1. Go to Railway Dashboard
2. Click on your service
3. Click ⋮ (three dots) → "Redeploy"

## 💰 Railway Pricing

- **Free tier**: 500 hours/month ($5 credit)
- **Perfect for**: Development, testing, personal use
- **Scales to**: Production with paid plans

## 📚 More Information

- Full Railway guide: `RAILWAY_DEPLOYMENT_GUIDE.md`
- Build timeout fix: `RAILWAY_BUILD_TIMEOUT_FIX.md`
- Troubleshooting 0 results: `RAILWAY_QUICK_FIX.md`
- Complete documentation: `README.md`

## 🎉 Success!

If you see the GarudRecon interface and `/api/tools` shows all tools available, you're ready to start scanning!

Need help? Check the documentation files or open an issue on GitHub.
