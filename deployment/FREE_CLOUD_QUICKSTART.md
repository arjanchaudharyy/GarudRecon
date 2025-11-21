# ⚡ FREE Cloud Deployment - 5 Minute Guide

Deploy GarudRecon to the cloud for **FREE** in just 5 minutes!

---

## 🎯 TL;DR - Fastest Method

### Render.com (1-Click, No Credit Card)

1. Click button → 2. Sign up → 3. Deploy → 4. Done! ✅

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/arjanchaudharyy/GarudRecon)

**Your app will be live at:** `https://garudrecon-xxx.onrender.com`

---

## 🆓 Free Tier Comparison

| Platform | RAM | Storage | Sleep? | Credit Card? |
|----------|-----|---------|--------|--------------|
| **Render** ⭐ | 512MB | 1GB | 15min | ❌ No |
| **Railway** | Varies | Good | Never | ❌ No |
| **Fly.io** | 256MB | 1GB | Auto-scale | ✅ Yes |

**Best choice:** Render.com (easiest, no card needed)

---

## 📱 Platform-Specific Guides

### Option 1: Render.com (Easiest) ⭐

**Time:** 3 minutes  
**Credit Card:** Not required  
**Best For:** Beginners, always-on hosting

#### Steps:

1. **Click deploy button:**
   
   [![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/arjanchaudharyy/GarudRecon)

2. **Sign up** (GitHub/GitLab/Email)

3. **Configure:**
   - Name: `garudrecon` (or any name)
   - Region: Select closest
   - Plan: **Free**

4. **Click "Create Web Service"**

5. **Wait ~5 minutes** for deployment

6. **Access your app!** 
   - URL: `https://your-app-name.onrender.com`

#### Keep It Awake

Free tier sleeps after 15 min. Keep it awake with:

**UptimeRobot (Free):**
1. Go to: https://uptimerobot.com
2. Sign up
3. Add Monitor:
   - Type: HTTP(s)
   - URL: Your Render URL
   - Interval: 5 minutes

---

### Option 2: Railway.app (Super Easy)

**Time:** 2 minutes  
**Credit Card:** Not required  
**Best For:** Quick deployments

#### Via Browser:

1. **Go to:** https://railway.app

2. **Click "Start a New Project"**

3. **Choose "Deploy from GitHub repo"**

4. **Connect GitHub** and select GarudRecon

5. **Add variables:**
   ```
   FLASK_ENV=production
   HOST=0.0.0.0
   PORT=${{PORT}}
   ```

6. **Generate Domain** in Settings

7. **Access your app!**

#### Via CLI:

```bash
# Install CLI
npm i -g @railway/cli

# Clone repo
git clone https://github.com/arjanchaudharyy/GarudRecon.git
cd GarudRecon

# Login & deploy
railway login
railway init
railway up

# Get URL
railway domain
```

---

### Option 3: Fly.io (Best Performance)

**Time:** 5 minutes  
**Credit Card:** Required (won't charge)  
**Best For:** Global deployment, auto-scaling

#### Steps:

```bash
# 1. Install CLI
curl -L https://fly.io/install.sh | sh

# 2. Sign up
fly auth signup

# 3. Clone repo
git clone https://github.com/arjanchaudharyy/GarudRecon.git
cd GarudRecon

# 4. Launch (follow prompts)
fly launch

# 5. Create storage volume
fly volumes create garudrecon_scans --size 1

# 6. Deploy
fly deploy

# 7. Open app
fly open
```

---

## ⚙️ Post-Deployment Setup

### 1. Test Your Deployment

```bash
# Replace with your URL
curl https://your-app.onrender.com/api/health
```

Should return: `{"status": "ok", ...}`

### 2. Try a Scan

1. Open your app URL in browser
2. Enter a domain (e.g., `example.com`)
3. Select **Light** scan
4. Click "Start Scan"
5. Wait for results

### 3. Update CORS (Optional)

If deploying to custom domain:

**Render:**
- Dashboard → Environment → Add variable:
  ```
  CORS_ORIGINS=https://yourdomain.com
  ```

**Railway:**
```bash
railway variables set CORS_ORIGINS=https://yourdomain.com
```

**Fly.io:**
```bash
fly secrets set CORS_ORIGINS=https://yourdomain.com
```

---

## 🚨 Important Limitations

### Free Tier Constraints:

**✅ Works Great:**
- Light scans (5-10 min)
- Basic reconnaissance
- Small targets

**⚠️ May Timeout:**
- Cool scans (20-30 min)
- Medium targets

**❌ Won't Work:**
- Ultra scans (1-2 hours)
- Large-scale scanning

### Solutions:

1. **Stick to Light scans** on free tier
2. **Upgrade to paid** ($5-10/month) for Cool scans
3. **Use VPS** for Ultra scans

---

## 💡 Pro Tips

### 1. Prevent Sleep (Render)

**Free options to ping your app:**
- UptimeRobot: https://uptimerobot.com
- Cron-job.org: https://cron-job.org
- StatusCake: https://statuscake.com

Set to ping every 10 minutes.

### 2. Monitor Usage

**Railway:**
```bash
railway status
```

**Fly.io:**
```bash
fly status
```

### 3. View Logs

**Render:** Dashboard → Logs

**Railway:**
```bash
railway logs
```

**Fly.io:**
```bash
fly logs
```

---

## 🆘 Troubleshooting

### App Won't Start

**Check:**
1. Dockerfile exists
2. Port is 5000
3. Environment variables set

**Fix:**
```bash
# Check logs
railway logs  # or fly logs
```

### Scans Timeout

**Solutions:**
1. Use Light scans only
2. Upgrade to paid tier
3. Increase timeout limits

### Out of Memory

**Solutions:**
1. Reduce scan complexity
2. Upgrade RAM
3. Use VPS for heavy scans

---

## 💰 When to Upgrade

### Stay on Free If:
- ✅ Only need Light scans
- ✅ Low usage (< 100 scans/month)
- ✅ Personal projects

### Upgrade If:
- ⚠️ Need Cool/Ultra scans
- ⚠️ High usage (> 100 scans/month)
- ⚠️ Production use

### Pricing:
- **Render:** $7/month (no sleep)
- **Railway:** $5/month + usage
- **Fly.io:** ~$2-5/month

---

## 📊 Which Platform?

### Choose Render If:
- ✅ You want easiest setup
- ✅ No credit card
- ✅ Don't mind 15min sleep

### Choose Railway If:
- ✅ You want fastest deploy
- ✅ Good developer experience
- ✅ Need quick iterations

### Choose Fly.io If:
- ✅ You want best performance
- ✅ Need global deployment
- ✅ Want auto-scaling

---

## ✅ Success Checklist

- [ ] Choose platform (Render recommended)
- [ ] Sign up for account
- [ ] Deploy using method above
- [ ] Test health endpoint
- [ ] Try a Light scan
- [ ] Set up monitoring (if Render)
- [ ] Bookmark your URL
- [ ] Share with team! 🎉

---

## 🎉 You're Live!

Your GarudRecon is now running in the cloud for **FREE**!

**Next Steps:**
1. ✅ Try a scan
2. ✅ Share your deployment
3. ✅ Read [full guide](../DEPLOY_FREE_CLOUD.md)
4. ✅ Consider paid tier for production

---

**Need Help?**
- Full Guide: [DEPLOY_FREE_CLOUD.md](../DEPLOY_FREE_CLOUD.md)
- Documentation: [README.md](../README.md)
- Deployment: [DEPLOYMENT.md](../DEPLOYMENT.md)

---

**Happy Scanning! 🚀**
