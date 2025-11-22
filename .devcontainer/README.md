# 🚀 Welcome to CTXREC Codespace!

Your development environment is ready. Here's how to get started:

## ⚡ Quick Start (3 Steps)

### Step 1: Install Reconnaissance Tools
```bash
sudo ./start_web.sh
```
This will automatically install all required tools (10-15 minutes).

### Step 2: Wait for Server to Start
The web server will start automatically on port 5000.

### Step 3: Access Web Interface
Click the "Open in Browser" notification for port 5000, or:
- Go to the **PORTS** tab
- Click the 🌐 globe icon next to port 5000

## 🛠️ Alternative: Quick Start Without Tools

If you just want to see the interface (tools won't work):
```bash
python3 web_backend.py
```

## 📚 Documentation

- `CODESPACE.md` - Complete Codespaces guide
- `WEB_INTERFACE_ENHANCED.md` - UI feature documentation
- `TESTING_GUIDE.md` - How to test all features
- `README.md` - Full project documentation

## 🐛 Troubleshooting

### Port not forwarding?
```bash
# Manually add port forwarding:
1. Click "PORTS" tab at bottom
2. Click "+" to add port
3. Enter: 5000
4. Click globe icon 🌐
```

### Tools not installing?
```bash
# Check installation status:
./check_tools.sh

# Manual install:
sudo ./install_basic_tools.sh
```

## 🎯 First Scan

1. Open web interface (port 5000)
2. Enter a test domain: `example.com`
3. Select scan type: **Light** (5-10 min)
4. Click **Start Scan**
5. Watch real-time logs!

## ⚠️ Important Notes

- **Storage:** 32GB limit, commit important results
- **Auto-stop:** Codespace stops after 30min idle (configurable)
- **Legal:** Only scan domains you own or have permission to test

## 🤝 Need Help?

- Open an issue: https://github.com/arjanchaudharyy/GarudRecon/issues
- Check logs: Look for error messages in terminal
- Review docs: Read `CODESPACE.md` for detailed help

---

**Created by:** [arjanchaudharyy](https://github.com/arjanchaudharyy)

Happy scanning! 🔍✨
