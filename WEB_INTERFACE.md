# GarudRecon Web Interface

A modern, user-friendly web interface for GarudRecon with three scan modes: Light, Cool, and Ultra.

## Features

🎯 **Three Scan Modes:**
- **Light**: Fast scan with basic recon and vulnerability checks (~5-10 minutes)
- **Cool**: Medium-level scan with subdomain enumeration and extensive checks (~20-30 minutes)
- **Ultra**: Comprehensive deep reconnaissance with all tools (~1-2 hours)

🚀 **Modern Web Interface:**
- Clean, responsive design
- Real-time scan progress tracking
- Live log streaming
- Download scan results
- View scan history

⚡ **RESTful API Backend:**
- Python Flask backend
- Asynchronous scan execution
- JSON results format
- Easy integration

## Quick Start

### 1. Install Dependencies

```bash
# Install Python dependencies
pip3 install -r requirements.txt

# Or use the startup script (recommended)
./start_web.sh
```

### 2. Start the Web Server

```bash
./start_web.sh
```

The web interface will be available at: **http://localhost:5000**

### 3. Use the Interface

1. Open your browser and navigate to http://localhost:5000
2. Enter your target domain (e.g., `example.com` or `support.example.com`)
3. Select a scan type:
   - **Light**: Quick reconnaissance
   - **Cool**: Medium-depth scan
   - **Ultra**: Full comprehensive scan
4. Click "Start Scan"
5. Monitor progress in real-time
6. View and download results when complete

## Scan Types Explained

### Light Scan 🚀
**Duration**: ~5-10 minutes  
**Perfect for**: Quick security assessments, initial recon

**Includes:**
- DNS resolution
- Common port scanning (21, 22, 80, 443, 8080, 8443)
- HTTP probing
- Basic URL discovery (Wayback Machine, Common Crawl)
- XSS vulnerability check (50 URLs)
- SQL injection check (20 URLs)
- Security headers analysis

**Use Case**: Quick vulnerability assessment of a single target, initial reconnaissance, time-sensitive scans.

### Cool Scan 🔥
**Duration**: ~20-30 minutes  
**Perfect for**: Medium-depth reconnaissance, wildcard domains

**Includes:**
- **Everything in Light, PLUS:**
- Subdomain enumeration (subfinder, assetfinder, amass)
- DNS resolution for all subdomains
- HTTP probing for all live hosts
- Extended port scanning (top 100 ports)
- Comprehensive URL discovery (multiple sources)
- JavaScript file discovery
- XSS testing (100 URLs)
- SQL injection testing (30 URLs)
- Subdomain takeover detection
- Technology detection

**Use Case**: Comprehensive domain reconnaissance, bug bounty hunting, security audits of medium-sized applications.

### Ultra Scan 💥
**Duration**: ~1-2 hours  
**Perfect for**: Deep reconnaissance, full security assessment

**Includes:**
- **Everything in Cool, PLUS:**
- Aggressive subdomain enumeration (all tools)
- Subdomain permutations
- Certificate transparency logs
- Multi-resolver DNS resolution
- Full port scanning (top 1000 ports or all ports)
- Extensive URL crawling (5+ tools)
- JavaScript analysis and endpoint extraction
- Parameter discovery
- Directory enumeration
- Comprehensive XSS testing (200 URLs)
- Advanced SQL injection testing (50 URLs, level 3, risk 2)
- Nuclei vulnerability scanning (all templates)
- Screenshot capture
- SSL/TLS analysis
- Complete security headers audit

**Use Case**: Full security assessment, penetration testing preparation, comprehensive attack surface mapping.

## API Endpoints

### Start a Scan
```bash
POST /api/scan
Content-Type: application/json

{
  "domain": "example.com",
  "scan_type": "light"  # or "cool" or "ultra"
}

Response: 202 Accepted
{
  "scan_id": "uuid",
  "domain": "example.com",
  "scan_type": "light",
  "status": "queued"
}
```

### Get Scan Status
```bash
GET /api/scan/{scan_id}

Response: 200 OK
{
  "scan_id": "uuid",
  "domain": "example.com",
  "scan_type": "light",
  "status": "running",  # or "completed", "failed"
  "log": ["line1", "line2", ...],
  "results": {...}  # Available when status is "completed"
}
```

### List All Scans
```bash
GET /api/scans

Response: 200 OK
{
  "scans": [
    {
      "scan_id": "uuid",
      "domain": "example.com",
      "scan_type": "light",
      "status": "completed",
      "created_at": "2024-01-01T12:00:00"
    },
    ...
  ]
}
```

### Health Check
```bash
GET /api/health

Response: 200 OK
{
  "status": "ok",
  "message": "GarudRecon Web API is running"
}
```

## Architecture

```
GarudRecon Web Interface
│
├── web_backend.py          # Flask API server
├── start_web.sh            # Startup script
├── requirements.txt        # Python dependencies
│
├── web/                    # Frontend assets
│   ├── index.html         # Main HTML
│   ├── style.css          # Styling
│   └── script.js          # JavaScript logic
│
├── cmd/                    # Scan scripts
│   ├── scan_light         # Light scan mode
│   ├── scan_cool          # Cool scan mode
│   └── scan_ultra         # Ultra scan mode
│
└── scans/                  # Scan results (auto-created)
    ├── light-*/
    ├── cool-*/
    └── ultra-*/
```

## Results Format

Each scan generates:
- `results.json` - Structured JSON results
- `summary.txt` - Human-readable summary
- Various output files depending on scan type

### Example results.json:
```json
{
  "scan_type": "light",
  "domain": "example.com",
  "start_time": "2024-01-01T12:00:00",
  "findings": {
    "dns_records": 3,
    "open_ports": 4,
    "urls_found": 150,
    "xss_findings": 2,
    "sqli_findings": 0
  },
  "end_time": "2024-01-01T12:08:00",
  "status": "completed"
}
```

## Configuration

### Change Server Port
Edit `web_backend.py`:
```python
app.run(host='0.0.0.0', port=5000, debug=True)
```

### Customize Scan Behavior
Edit the scan scripts in `cmd/`:
- `cmd/scan_light` - Light scan configuration
- `cmd/scan_cool` - Cool scan configuration
- `cmd/scan_ultra` - Ultra scan configuration

### Tool Configuration
Edit `configuration/garudrecon.cfg` for tool-specific settings.

## Tips & Best Practices

1. **Start with Light**: Always start with a Light scan to get quick results
2. **Cool for Subdomains**: Use Cool scan when you need subdomain enumeration
3. **Ultra for Deep Dive**: Use Ultra only when you need comprehensive coverage
4. **Monitor Resources**: Ultra scans are resource-intensive
5. **Check Permissions**: Ensure you have permission to scan target domains
6. **VPS Recommended**: For Ultra scans, use a VPS with good bandwidth

## Troubleshooting

### Port Already in Use
```bash
# Find and kill process on port 5000
lsof -ti:5000 | xargs kill -9
```

### Scan Not Starting
- Check that scan scripts are executable: `chmod +x cmd/scan_*`
- Verify Python dependencies: `pip3 install -r requirements.txt`
- Check logs in scan output directory

### No Tools Found
- Install required tools using: `garudrecon install -f ALL`
- Or install specific tool sets based on scan type

## Security Notes

⚠️ **Important:**
- Always get permission before scanning any domain
- Some scans may be detected as attacks
- Use responsibly and ethically
- Follow bug bounty program rules
- Respect rate limits and robots.txt

## Browser Compatibility

- ✅ Chrome/Chromium (recommended)
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ⚠️ IE11 (limited support)

## Requirements

- Python 3.7+
- Flask 3.0.0+
- Modern web browser
- GarudRecon tools (install via `garudrecon install -f ALL`)

## Support

For issues, questions, or contributions:
- Check the main README.md
- Review scan logs in `scans/` directory
- Ensure all required tools are installed

## License

This web interface follows the same license as GarudRecon (MIT).

---

Made with ❤️ for Security Researchers
