# GarudRecon Quick Start Guide

Get started with GarudRecon in 3 easy steps!

## 🚀 Quick Start (Web Interface - Recommended)

### Step 1: Clone & Install
```bash
git clone https://github.com/arjanchaudharyy/GarudRecon.git
cd GarudRecon
```

### Step 2: Start Web Interface
```bash
./start_web.sh
```

Or using the garudrecon command:
```bash
./garudrecon web
```

### Step 3: Open Browser
Navigate to: **http://localhost:5000**

That's it! 🎉

---

## 📖 Using the Web Interface

### 1. Enter Your Target Domain
- Type domain without `http://` or `https://`
- Examples: `example.com`, `support.example.com`

### 2. Choose Scan Type

#### ⚡ Light Scan (5-10 min)
**Best for:** Quick checks, initial recon
- DNS resolution
- Port scanning (common ports)
- Basic vulnerability checks
- Security headers

#### 🔥 Cool Scan (20-30 min)
**Best for:** Bug bounties, medium audits
- Subdomain enumeration
- Extended port scanning
- URL discovery
- XSS & SQLi testing
- Subdomain takeover

#### 🚀 Ultra Scan (1-2 hours)
**Best for:** Deep pentesting, full audits
- Aggressive subdomain enumeration
- Comprehensive vulnerability scanning
- Directory bruteforcing
- JavaScript analysis
- Nuclei scanning
- Screenshots

### 3. Monitor Progress
- Watch live logs
- Track scan status
- View results in real-time

### 4. Download Results
- Click "Download Results" when complete
- JSON format with all findings

---

## 💻 Command Line Usage (Advanced)

### Light Scan
```bash
./cmd/scan_light -d example.com -o output/
```

### Cool Scan
```bash
./cmd/scan_cool -d example.com -o output/
```

### Ultra Scan
```bash
./cmd/scan_ultra -d example.com -o output/
```

---

## 🛠️ Installing Tools

GarudRecon requires various security tools. Install them using:

```bash
./garudrecon install -f ALL
```

Or install by scope:
```bash
./garudrecon install -f SMALLSCOPE   # For light scans
./garudrecon install -f MEDIUMSCOPE  # For cool scans
./garudrecon install -f LARGESCOPE   # For ultra scans
```

---

## 🔧 Troubleshooting

### Web Server Won't Start

**Problem:** Port 5000 already in use
```bash
# Kill the process using port 5000
lsof -ti:5000 | xargs kill -9
./start_web.sh
```

**Problem:** Python not found
```bash
# Install Python 3
sudo apt install python3 python3-pip python3-venv
```

### Scan Fails to Start

**Problem:** Tools not installed
```bash
./garudrecon install -f ALL
```

**Problem:** Permission denied
```bash
chmod +x cmd/scan_*
chmod +x start_web.sh
```

### No Results

**Problem:** Domain doesn't resolve
- Check domain spelling
- Try with/without `www`
- Ensure domain is accessible

**Problem:** Scan timeout
- Light scan: Should complete in 10 min
- Cool scan: Should complete in 30 min
- Ultra scan: May take up to 2 hours

---

## 📁 Where Are Results?

All scan results are stored in:
```
scans/
├── light-YYYYMMDD-HHMMSS-domain.com/
├── cool-YYYYMMDD-HHMMSS-domain.com/
└── ultra-YYYYMMDD-HHMMSS-domain.com/
```

Each scan directory contains:
- `results.json` - Structured results
- `summary.txt` - Human-readable summary
- Various tool outputs

---

## 🎯 Scan Type Comparison

| Feature | Light ⚡ | Cool 🔥 | Ultra 🚀 |
|---------|---------|---------|----------|
| Duration | 5-10 min | 20-30 min | 1-2 hours |
| Subdomains | Single | Yes | Extensive |
| Port Scan | Common | Top 100 | Top 1000+ |
| URL Discovery | Basic | Good | Extensive |
| Vuln Checks | Basic | Medium | Deep |
| Screenshots | No | No | Yes |
| Best For | Quick check | Bug bounty | Full audit |

---

## ⚠️ Important Notes

1. **Always Get Permission** - Only scan domains you own or have permission to test
2. **Rate Limiting** - Aggressive scans may trigger rate limits
3. **Legal** - Unauthorized scanning is illegal in most jurisdictions
4. **Resources** - Ultra scans are CPU/bandwidth intensive
5. **VPS Recommended** - For production use, run on a VPS

---

## 🆘 Need Help?

- **Web Interface Guide**: See [WEB_INTERFACE.md](WEB_INTERFACE.md)
- **Full Documentation**: See [README.md](README.md)
- **Issues**: Check GitHub issues
- **Logs**: Check `scans/` directory for scan logs

---

## 🎓 Tips for Beginners

1. **Start Small**: Always begin with Light scan
2. **Test on Your Own Domains**: Practice on domains you own
3. **Review Results**: Learn to interpret findings
4. **Understand Tools**: Research the tools being used
5. **Stay Legal**: Never scan without permission

---

## 🚀 Next Steps

Once comfortable with basics:

1. **Customize Scans**: Edit scan scripts in `cmd/`
2. **API Integration**: Use REST API for automation
3. **Cron Jobs**: Set up continuous monitoring
4. **Report Generation**: Build custom reporting
5. **Tool Tuning**: Configure tools in `configuration/`

---

Made with ❤️ for Security Researchers

**Happy Hacking! 🎉**
