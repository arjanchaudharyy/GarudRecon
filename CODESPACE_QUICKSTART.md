# ⚡ Codespace Quick Start - 3 Minutes to Running!

## 🎯 For First-Time Users

### 1️⃣ Open Codespace (30 seconds)

**Option A: From GitHub**
```
1. Go to: https://github.com/arjanchaudharyy/GarudRecon
2. Click: Green "Code" button
3. Click: "Codespaces" tab
4. Click: "Create codespace on main"
```

**Option B: Quick URL**
```
https://github.com/codespaces/new?repo=arjanchaudharyy/GarudRecon
```

### 2️⃣ Wait for Setup (2-3 minutes)

You'll see:
```
🔧 Setting up CTXREC environment...
Installing Python packages...
Making scripts executable...
✅ Codespace ready!
```

### 3️⃣ Start the Server (2 ways)

**Fast Way (No Tools - 5 seconds)**
```bash
python3 web_backend.py
```
- ✅ Web interface works
- ❌ Scans won't work (tools not installed)
- 📝 Good for: UI testing, development

**Complete Way (With Tools - 15 minutes)**
```bash
sudo ./start_web.sh
```
- ✅ Web interface works
- ✅ All scanning tools installed
- ✅ Full functionality
- 📝 Good for: Actual scanning, production use

### 4️⃣ Access Web Interface (10 seconds)

**Automatic:**
- Click the notification: "Open in Browser" (port 5000)

**Manual:**
```
1. Click "PORTS" tab at bottom
2. Find port 5000
3. Click globe icon 🌐
```

**URL Format:**
```
https://[your-username-codespace-name]-5000.app.github.dev
```

---

## 🎬 Full Example Session

```bash
# Terminal opens automatically in Codespace

# Option 1: Quick preview (no tools)
$ python3 web_backend.py
Starting server on http://0.0.0.0:5000
✨ Click the port 5000 notification!

# Option 2: Full install (with tools)
$ sudo ./start_web.sh
[*] Checking for missing tools...
[*] Installing httpx, subfinder, nuclei...
[*] This will take 10-15 minutes...
☕ Grab a coffee!

✅ All tools installed!
🚀 Server starting on port 5000...
✨ Access at: https://[codespace]-5000.app.github.dev
```

---

## 🎯 Your First Scan

1. **Open web interface** (click port 5000)
2. **Enter domain**: `example.com`
3. **Select**: Light scan (5-10 min)
4. **Click**: Start Scan
5. **Watch**: Real-time color-coded logs!

**Results in:**
```
🌐 DNS Records: 1
🔌 Open Ports: 2
🔗 URLs Found: 150
⚠️ XSS Issues: 3
💉 SQLi Issues: 0
```

---

## 🔥 Pro Tips

### Tip 1: Skip Tool Installation for Development
If you're just developing the UI or backend:
```bash
# Start without tools (instant)
python3 web_backend.py

# Make changes to web/script.js, web/style.css, etc.
# Refresh browser to see changes
```

### Tip 2: Make Port Public for Team
Share your running instance with team:
```
1. PORTS tab → Right-click port 5000
2. Port Visibility → Public
3. Share URL with team
```

### Tip 3: Use Multiple Terminals
```
Terminal 1: Server (python3 web_backend.py)
Terminal 2: Testing (./check_tools.sh)
Terminal 3: Git commands (git status, git commit)
```

### Tip 4: Save Results Before Stopping
```bash
# Download via web UI (Download button)
# OR commit to git
git add scans/important-scan/
git commit -m "Save scan results"
git push
```

---

## 🐛 Common Issues (Solved in 30 Seconds)

### "Port 5000 not found"
```bash
# Solution: Check if server is running
ps aux | grep web_backend

# If not running:
python3 web_backend.py
```

### "Permission denied"
```bash
# Solution: Make scripts executable
chmod +x start_web.sh check_tools.sh
```

### "Tools not working"
```bash
# Solution: Install tools
sudo ./start_web.sh
# OR check what's missing
./check_tools.sh
```

### "Codespace slow"
```bash
# Solution: Upgrade machine type
Settings → Codespaces → Machine type → 4-core

# Or use Light scan instead of Ultra
# Light: 5-10 min (fast)
# Ultra: 1-2 hours (slow)
```

---

## 📊 Comparison: No Tools vs With Tools

| Feature | No Tools | With Tools |
|---------|----------|------------|
| Startup Time | 5 seconds | 15 minutes |
| Web UI | ✅ Works | ✅ Works |
| Scans | ❌ 0 results | ✅ Full results |
| Development | ✅ Perfect | ✅ Perfect |
| Production | ❌ Not usable | ✅ Ready |
| Good for | UI dev, testing | Actual scanning |

**Recommendation:**
- 👨‍💻 Developers: Start without tools, install later if needed
- 🔒 Security testers: Install tools immediately
- 🎓 Students: Install tools to learn

---

## 🎓 Learning Path

### Day 1: Interface Exploration (No Tools)
```bash
python3 web_backend.py
# Explore UI, understand features, read documentation
```

### Day 2: Tool Installation
```bash
sudo ./start_web.sh
# Learn what each tool does, check logs
```

### Day 3: First Scan
```bash
# Scan a test domain
Domain: example.com
Type: Light
# Watch logs, understand output
```

### Day 4: Advanced Scanning
```bash
# Try Cool and Ultra scans
# Analyze results, view generated files
```

---

## 📱 Mobile Access

Yes, Codespaces work on mobile!

1. Open GitHub app (iOS/Android)
2. Go to repository
3. Create Codespace
4. Opens in mobile browser with VS Code
5. Access web interface via port forwarding

**Note:** Better on tablet than phone due to screen size

---

## 💰 Cost Awareness

**Free tier:** 60 hours/month

**Tips to save hours:**
```bash
# Always stop when done (not just close tab)
Codespaces → ⋮ → Stop Codespace

# Set auto-stop timeout
Settings → Codespaces → Default idle timeout → 30 min

# Use smaller machine (2-core) for development
Only upgrade to 4-core for actual scanning
```

**Cost calculation:**
- Development (2-core): Free tier covers it
- Light scan (2-core): ~10 min = 0.16 hours
- Cool scan (4-core): ~30 min = 0.5 hours ($0.09)
- Ultra scan (8-core): ~2 hours = 2 hours ($0.36)

---

## 🚀 Ready in 3 Commands

```bash
# 1. Create Codespace (on GitHub website)

# 2. Install tools
sudo ./start_web.sh

# 3. Access web interface
# (Click port 5000 notification)
```

**Total time:** 15-20 minutes

---

## 📚 Next Steps

After getting it running:

1. ✅ Read `CODESPACE.md` - Full guide
2. ✅ Read `WEB_INTERFACE_ENHANCED.md` - UI features
3. ✅ Read `TESTING_GUIDE.md` - Test all features
4. ✅ Start scanning! 🔍

---

## 🎉 You're Ready!

**Most common first experience:**

```bash
$ python3 web_backend.py
✅ Server started!

# Click notification → Web UI opens
# Enter example.com → Start Light scan
# Wait 5 minutes → See 0 results
# Realize tools aren't installed 😅

$ sudo ./start_web.sh
# Wait 15 minutes...
✅ Tools installed!

# Run scan again → See actual results! 🎉
# 150 URLs, 3 XSS issues, 12 Nuclei findings!
```

---

**Questions? Issues? Feedback?**

Open an issue: https://github.com/arjanchaudharyy/GarudRecon/issues

**Happy scanning in the cloud!** ☁️⚡
