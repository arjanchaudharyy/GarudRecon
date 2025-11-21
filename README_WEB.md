# 🚀 GarudRecon Web Interface - Quick Reference

> **Transform security scanning from complex command-line operations into a simple, beautiful web experience!**

## ⚡ Fastest Way to Start

```bash
./start_web.sh
```

Then open: **http://localhost:5000**

That's it! 🎉

---

## 🎯 What You Get

### Three Scan Modes - Choose Your Speed

| Mode | Duration | Best For |
|------|----------|----------|
| **⚡ Light** | 5-10 min | Quick checks, initial recon |
| **🔥 Cool** | 20-30 min | Bug bounties, medium audits |
| **🚀 Ultra** | 1-2 hours | Full pentesting, deep scans |

### Modern Web Interface

- ✨ Beautiful dark-themed design
- 📊 Real-time progress tracking
- 📝 Live scan logs
- 💾 Download results as JSON
- 📜 Scan history
- 📱 Mobile responsive

### REST API

```bash
# Start a scan
curl -X POST http://localhost:5000/api/scan \
  -H "Content-Type: application/json" \
  -d '{"domain": "example.com", "scan_type": "light"}'

# Check status
curl http://localhost:5000/api/scan/{scan_id}
```

---

## 📚 Documentation Roadmap

### 🎓 Learning Path

1. **Start Here** → [QUICKSTART.md](QUICKSTART.md)
   - Get up and running in 5 minutes
   - Step-by-step instructions
   - Perfect for beginners

2. **Web Interface** → [WEB_INTERFACE.md](WEB_INTERFACE.md)
   - Complete web interface guide
   - API documentation
   - Architecture details

3. **Examples** → [EXAMPLES.md](EXAMPLES.md)
   - 15+ real-world examples
   - CLI, API, and automation
   - Bug bounty workflows

4. **Features** → [FEATURES.md](FEATURES.md)
   - Complete feature list
   - Tool integration
   - Comparison tables

5. **Contributing** → [CONTRIBUTING.md](CONTRIBUTING.md)
   - How to contribute
   - Code style guide
   - Development setup

---

## 🎨 Scan Mode Comparison

### ⚡ Light Scan
```
✓ DNS resolution
✓ Port scan (6 common ports)
✓ HTTP probing
✓ URL discovery (1000 URLs)
✓ XSS check (50 URLs)
✓ SQLi check (20 URLs)
✓ Security headers

Perfect for: Quick wins, CI/CD
```

### 🔥 Cool Scan
```
✓ Everything in Light, PLUS:
✓ Subdomain enumeration (3+ tools)
✓ Extended ports (100)
✓ Deep URL discovery (5000+ URLs)
✓ JavaScript files
✓ Extended XSS (100 URLs)
✓ Extended SQLi (30 URLs)
✓ Subdomain takeover
✓ Tech detection

Perfect for: Bug bounties, recon
```

### 🚀 Ultra Scan
```
✓ Everything in Cool, PLUS:
✓ Aggressive subdomains (7+ tools)
✓ Subdomain permutations
✓ Certificate transparency
✓ Full ports (1000+)
✓ Extensive crawling (5+ tools)
✓ JS endpoint extraction
✓ Parameter discovery
✓ Directory enumeration
✓ Deep XSS (200 URLs)
✓ Advanced SQLi (level 3)
✓ Nuclei scanning
✓ Screenshots
✓ Complete audit

Perfect for: Pentesting, deep analysis
```

---

## 💻 Usage Examples

### Web Interface (Easiest)
1. Start: `./start_web.sh`
2. Open: http://localhost:5000
3. Enter domain
4. Select scan type
5. Click "Start Scan"
6. Monitor progress
7. Download results

### Command Line
```bash
# Light scan
./cmd/scan_light -d example.com -o output/

# Cool scan
./cmd/scan_cool -d example.com -o output/

# Ultra scan
./cmd/scan_ultra -d example.com -o output/
```

### API Integration
```python
import requests

# Start scan
response = requests.post(
    'http://localhost:5000/api/scan',
    json={'domain': 'example.com', 'scan_type': 'cool'}
)
scan_id = response.json()['scan_id']

# Check status
status = requests.get(f'http://localhost:5000/api/scan/{scan_id}')
print(status.json())
```

---

## 🛠️ Setup & Requirements

### Quick Setup
```bash
# Clone (if not already)
git clone https://github.com/rix4uni/GarudRecon.git
cd GarudRecon

# Start (handles everything automatically)
./start_web.sh
```

### Manual Setup
```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start server
python3 web_backend.py
```

### Requirements
- Python 3.7+
- Flask 3.0.0+
- Modern web browser
- Security tools (optional, install with `garudrecon install -f ALL`)

---

## 📁 Output Structure

### Light Scan
```
light-20240101-120000-example.com/
├── results.json              # Structured results
├── summary.txt               # Human-readable
├── dns_a_records.txt
├── ports.txt
├── httpx.txt
├── urls.txt
├── xss_findings.txt
└── sqli_findings.txt
```

### Cool Scan
```
cool-20240101-120000-example.com/
├── results.json
├── summary.txt
├── subdomains.txt
├── resolved_subdomains.txt
├── httpx.txt
├── ports.txt
├── urls.txt
├── js_files.txt
├── xss_findings.txt
├── sqli_findings.txt
└── subdomain_takeover.txt
```

### Ultra Scan
```
ultra-20240101-120000-example.com/
├── results.json
├── summary.txt
├── subdomains/          # All subdomain data
├── reconnaissance/      # URLs, ports, JS
├── vulnerabilities/     # Security findings
└── screenshots/         # Visual captures
```

---

## ⚠️ Important Notes

### Legal & Ethical
- ⚠️ **Only scan domains you own or have permission to test**
- ⚠️ Unauthorized scanning is illegal
- ⚠️ Respect rate limits and robots.txt
- ⚠️ Use responsibly and ethically

### Performance
- Light scans are fast and safe
- Cool scans are moderate
- Ultra scans are resource-intensive (use VPS)

### Security
- Results may contain sensitive data
- Store results securely
- Delete results when done
- Results are in .gitignore

---

## 🆘 Troubleshooting

### Server Won't Start
```bash
# Kill any process on port 5000
lsof -ti:5000 | xargs kill -9

# Restart
./start_web.sh
```

### Scan Fails
```bash
# Check permissions
chmod +x cmd/scan_*

# Test setup
./test_web.sh

# Check logs
tail -f scans/*/summary.txt
```

### No Results
- Verify domain is accessible
- Check domain spelling
- Ensure tools are installed
- Review scan logs

---

## 🎯 Common Use Cases

### Bug Bounty Hunter
1. Start with **Cool scan**
2. Review subdomains
3. Focus on interesting targets
4. Run targeted tests

### Security Auditor
1. Use **Ultra scan**
2. Comprehensive coverage
3. Generate reports
4. Document findings

### Continuous Monitoring
1. Set up **Light scans**
2. Run daily/weekly
3. Compare results
4. Alert on changes

### Penetration Tester
1. Begin with **Cool scan**
2. Identify attack surface
3. Dive deep with **Ultra**
4. Manual verification

---

## 🚀 Pro Tips

1. **Start Small**: Always begin with Light scan
2. **Test Legally**: Only scan authorized targets
3. **Save Results**: Important findings should be archived
4. **Learn Tools**: Understand what each tool does
5. **Combine Methods**: Use CLI, Web, and API together
6. **Monitor Resources**: Ultra scans need bandwidth
7. **Read Docs**: Check documentation for advanced features
8. **Stay Updated**: Keep tools and framework current

---

## 📞 Getting Help

### Documentation
- 🎓 [QUICKSTART.md](QUICKSTART.md) - Beginner guide
- 🌐 [WEB_INTERFACE.md](WEB_INTERFACE.md) - Web docs
- 📚 [EXAMPLES.md](EXAMPLES.md) - Usage examples
- ⚡ [FEATURES.md](FEATURES.md) - Feature list
- 📝 [CHANGELOG.md](CHANGELOG.md) - Changes
- 🤝 [CONTRIBUTING.md](CONTRIBUTING.md) - Contribute

### Quick Commands
```bash
./garudrecon -h          # Help
./test_web.sh            # Test setup
./start_web.sh           # Start server
./garudrecon web         # Alternative start
```

---

## 🎉 Quick Start Recap

1. **Launch**: `./start_web.sh`
2. **Access**: http://localhost:5000
3. **Scan**: Enter domain → Select mode → Start
4. **Monitor**: Watch progress in real-time
5. **Download**: Save results when complete

**That's it!** You're ready to start securing the web! 🛡️

---

## 📊 Quick Stats

- 🎯 **3 Scan Modes**: Light, Cool, Ultra
- ⚡ **Speed**: From 5 minutes to 2 hours
- 🛠️ **50+ Tools**: Integrated security tools
- 📝 **JSON Output**: Structured results
- 🌐 **REST API**: Full programmatic access
- 📱 **Responsive**: Works on all devices
- 🐳 **Docker Ready**: Container deployment
- 📚 **Well Documented**: 8 comprehensive guides

---

**Made with ❤️ for Security Researchers**

**Happy Hunting! 🎯🔍🛡️**
