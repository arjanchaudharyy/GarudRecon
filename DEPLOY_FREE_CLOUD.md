# 🌐 Deploy GarudRecon on FREE Cloud Platforms

Deploy GarudRecon for **FREE** using these cloud platforms. No credit card required for most!

---

## 🎯 Best Free Cloud Options

| Platform | Free Tier | Best For | Deploy Time |
|----------|-----------|----------|-------------|
| **Render.com** ⭐ | Always-on, 512MB RAM | Best overall | ~5 min |
| **Railway.app** | $5 free/month credits | Easy deployment | ~3 min |
| **Fly.io** | 3 VMs free | Auto-scale to zero | ~5 min |

---

## 1️⃣ Render.com (Recommended - Easiest)

### Why Render?
- ✅ True free tier (no credit card needed)
- ✅ 750 hours/month (always-on capable)
- ✅ Docker support
- ✅ Persistent storage (1GB)
- ✅ Auto SSL certificates
- ⚠️ Sleeps after 15 min inactivity (wakes in ~30s)

### Deploy to Render

#### Option A: One-Click Deploy (Easiest)

1. **Click this button:**

   [![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/arjanchaudharyy/GarudRecon)

2. **Sign up/Login** to Render.com

3. **Configure:**
   - Name: `garudrecon` (or your choice)
   - Region: Choose closest to you
   - Plan: **Free**

4. **Deploy!** (takes ~5 minutes)

5. **Access:** Your app will be at `https://garudrecon-xxx.onrender.com`

#### Option B: Manual Deploy

```bash
# 1. Fork the repo on GitHub

# 2. Go to Render Dashboard
https://dashboard.render.com

# 3. Click "New +" → "Web Service"

# 4. Connect your GitHub repo

# 5. Configure:
Name: garudrecon
Region: Oregon (or your choice)
Branch: main
Root Directory: .
Environment: Docker
Plan: Free

# 6. Add Environment Variables:
FLASK_ENV=production
HOST=0.0.0.0
PORT=5000
SECRET_KEY=(click Generate)
CORS_ORIGINS=*

# 7. Click "Create Web Service"
```

#### Keep Render App Awake

Render free tier sleeps after 15 minutes. To keep it awake:

**Method 1: Use a free ping service**
- Visit: https://cron-job.org (free account)
- Add job: Ping your Render URL every 10 minutes

**Method 2: Use UptimeRobot**
- Visit: https://uptimerobot.com (free account)
- Monitor your app URL

---

## 2️⃣ Railway.app (Super Easy)

### Why Railway?
- ✅ $5 free credits/month
- ✅ No credit card for trial
- ✅ Excellent Docker support
- ✅ Instant deployments
- ✅ Great developer experience

### Deploy to Railway

#### Quick Deploy

1. **Install Railway CLI:**
   ```bash
   npm i -g @railway/cli
   # Or: curl -fsSL https://railway.app/install.sh | sh
   ```

2. **Clone & Deploy:**
   ```bash
   # Clone repo
   git clone https://github.com/arjanchaudharyy/GarudRecon.git
   cd GarudRecon

   # Login to Railway
   railway login

   # Initialize project
   railway init

   # Deploy!
   railway up
   ```

3. **Get URL:**
   ```bash
   railway domain
   ```

#### Via Dashboard

1. **Go to:** https://railway.app

2. **Click "Start a New Project"**

3. **Choose "Deploy from GitHub repo"**

4. **Select GarudRecon repo**

5. **Add variables:**
   ```
   FLASK_ENV=production
   HOST=0.0.0.0
   CORS_ORIGINS=*
   ```

6. **Generate domain** in settings

7. **Access your app!**

---

## 3️⃣ Fly.io (Best for Scaling)

### Why Fly?
- ✅ 3 free VMs (2GB total)
- ✅ Auto-scale to zero (saves resources)
- ✅ Global deployment
- ✅ Persistent volumes
- ⚠️ Requires credit card (won't charge on free tier)

### Deploy to Fly.io

1. **Install Fly CLI:**
   ```bash
   # Linux/Mac
   curl -L https://fly.io/install.sh | sh

   # Windows
   powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"
   ```

2. **Sign up:**
   ```bash
   fly auth signup
   # Or login: fly auth login
   ```

3. **Clone repo:**
   ```bash
   git clone https://github.com/arjanchaudharyy/GarudRecon.git
   cd GarudRecon
   ```

4. **Launch app:**
   ```bash
   fly launch
   ```

   Answer prompts:
   - App name: `garudrecon` (or your choice)
   - Region: Choose closest
   - Database: No
   - Deploy now: Yes

5. **Create volume for scans:**
   ```bash
   fly volumes create garudrecon_scans --size 1
   ```

6. **Deploy:**
   ```bash
   fly deploy
   ```

7. **Open app:**
   ```bash
   fly open
   ```

---

## 🆓 Alternative Free Options

### 4️⃣ Koyeb

**Free Tier:**
- 1 web service
- 512MB RAM
- Docker support

**Deploy:**
```bash
# 1. Go to: https://app.koyeb.com
# 2. Connect GitHub
# 3. Select GarudRecon repo
# 4. Deploy!
```

### 5️⃣ Cyclic.sh

**Free Tier:**
- Unlimited apps
- 10K requests/month
- Serverless

**Deploy:**
```bash
# 1. Go to: https://app.cyclic.sh
# 2. Connect GitHub
# 3. Select repo
# 4. Deploy
```

### 6️⃣ Northflank

**Free Tier:**
- $25 credits/month
- Docker support
- Persistent storage

**Deploy:**
```bash
# 1. Go to: https://northflank.com
# 2. Create project
# 3. Deploy from GitHub
```

---

## ⚙️ Configuration for Cloud Deployment

### Environment Variables

All platforms need these:

```bash
FLASK_ENV=production
HOST=0.0.0.0
PORT=5000  # Or use $PORT for auto-assigned
SECRET_KEY=<generate-random-key>
CORS_ORIGINS=*  # Update with your domain later
```

### Generate Secret Key

```bash
python3 -c 'import secrets; print(secrets.token_hex(32))'
```

---

## 📊 Platform Comparison

| Feature | Render | Railway | Fly.io |
|---------|--------|---------|--------|
| **Free RAM** | 512MB | Varies | 256MB |
| **Free Storage** | 1GB | Limited | 1GB volume |
| **Sleep Policy** | 15min | No | Auto-scale |
| **Docker Support** | ✅ | ✅ | ✅ |
| **Custom Domain** | ✅ | ✅ | ✅ |
| **SSL** | ✅ Auto | ✅ Auto | ✅ Auto |
| **Credit Card** | ❌ Not needed | ❌ Not needed | ✅ Required |
| **Deploy Time** | ~5 min | ~3 min | ~5 min |
| **Best For** | Always-on | Quick deploy | Global apps |

---

## 🚨 Important Notes

### Scan Limitations on Free Tiers

**Light Scans:** ✅ Work perfectly  
**Cool Scans:** ⚠️ May timeout on free tier (30-60s limits)  
**Ultra Scans:** ❌ Not recommended (too long for free tier)

### Recommendations:

1. **For Light scans only:** Use Render.com free tier
2. **For Cool scans:** Use Railway or upgrade to paid tier
3. **For Ultra scans:** Use VPS or paid cloud tier

### Keep-Alive Tips:

Most free tiers sleep after inactivity. Use:
- **UptimeRobot** (free): https://uptimerobot.com
- **Cron-job.org** (free): https://cron-job.org
- Set to ping your URL every 10 minutes

---

## 🎯 Quick Start Summary

### Fastest Deployment (Render.com):

1. **Click:** [![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/arjanchaudharyy/GarudRecon)
2. **Sign up** (no credit card)
3. **Deploy** (automatic)
4. **Access** your app!

### Via Railway CLI:

```bash
npm i -g @railway/cli
git clone https://github.com/arjanchaudharyy/GarudRecon.git
cd GarudRecon
railway login
railway init
railway up
railway domain
```

### Via Fly.io:

```bash
curl -L https://fly.io/install.sh | sh
git clone https://github.com/arjanchaudharyy/GarudRecon.git
cd GarudRecon
fly launch
fly deploy
fly open
```

---

## 🆘 Troubleshooting

### App Won't Start

**Check logs:**
```bash
# Render: Dashboard → Logs
# Railway: railway logs
# Fly.io: fly logs
```

**Common issues:**
- Port not set to 5000
- Missing environment variables
- Dockerfile not found

### App Keeps Sleeping

**Solutions:**
- Set up ping service (UptimeRobot)
- Upgrade to paid tier
- Use Fly.io auto-scale

### Scans Timeout

**Solutions:**
- Use Light scans only on free tier
- Upgrade to paid tier for Cool/Ultra
- Use VPS for heavy scanning

---

## 💰 Cost Comparison

| Platform | Free Tier | Paid Tier (Recommended) |
|----------|-----------|------------------------|
| **Render** | $0 (512MB) | $7/mo (512MB, no sleep) |
| **Railway** | $5 credit | $5/mo for usage |
| **Fly.io** | $0 (256MB) | $1.94/mo (256MB) |

**For production use:** Paid tier recommended ($5-10/month)

---

## 📚 Additional Resources

- **Render Docs:** https://render.com/docs
- **Railway Docs:** https://docs.railway.app
- **Fly.io Docs:** https://fly.io/docs

---

## ✅ Success Checklist

- [ ] Choose a platform (Render recommended)
- [ ] Sign up for account
- [ ] Deploy using method above
- [ ] Access your app URL
- [ ] Test with a Light scan
- [ ] Set up keep-alive (if using Render)
- [ ] Update CORS_ORIGINS with your domain
- [ ] Share your deployment! 🎉

---

## 🎉 You're Live!

Your GarudRecon is now running in the cloud for **FREE**!

**What's Next:**
1. Try a Light scan
2. Bookmark your URL
3. Set up monitoring
4. Consider paid tier for production

**Happy Scanning! 🚀**

---

Made with ❤️ for Security Researchers
