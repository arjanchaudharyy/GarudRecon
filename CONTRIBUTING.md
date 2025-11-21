# Contributing to GarudRecon

Thank you for your interest in contributing to GarudRecon! This guide will help you get started.

## 🎯 Ways to Contribute

1. **Report Bugs**: Open an issue with details
2. **Suggest Features**: Share your ideas
3. **Improve Documentation**: Fix typos, add examples
4. **Add Tools**: Integrate new security tools
5. **Optimize Code**: Performance improvements
6. **Write Tests**: Increase test coverage

## 🚀 Getting Started

### 1. Fork & Clone
```bash
git clone https://github.com/yourusername/GarudRecon.git
cd GarudRecon
```

### 2. Set Up Development Environment
```bash
# Install Python dependencies
pip3 install -r requirements.txt

# Make scripts executable
chmod +x cmd/scan_* start_web.sh test_web.sh garudrecon

# Test setup
./test_web.sh
```

### 3. Create a Branch
```bash
git checkout -b feature/your-feature-name
```

## 📁 Project Structure

### Core Files
```
GarudRecon/
├── garudrecon              # Main CLI entry point
├── web_backend.py          # Flask API server
├── start_web.sh            # Web server launcher
├── requirements.txt        # Python dependencies
└── configuration/
    └── garudrecon.cfg      # Main configuration
```

### Scan Scripts
```
cmd/
├── scan_light              # Light scan mode
├── scan_cool               # Cool scan mode
├── scan_ultra              # Ultra scan mode
├── smallscope              # Legacy: minimal recon
├── mediumscope             # Legacy: moderate recon
├── largescope              # Legacy: full recon
├── install                 # Tool installation
└── cronjobs                # Scheduled scans
```

### Frontend
```
web/
├── index.html              # Main UI
├── style.css               # Styling
└── script.js               # API interaction
```

### Documentation
```
├── README.md               # Main documentation
├── QUICKSTART.md           # Beginner guide
├── WEB_INTERFACE.md        # Web interface docs
├── EXAMPLES.md             # Usage examples
├── FEATURES.md             # Feature list
├── CHANGELOG.md            # Change history
├── SUMMARY.md              # Project summary
└── CONTRIBUTING.md         # This file
```

## 🔧 Development Guidelines

### Code Style

#### Bash Scripts
```bash
# Use meaningful variable names
DOMAIN="example.com"
OUTPUT_DIR="scans/output"

# Add comments for complex logic
# Check if domain resolves before scanning
if ! host "$DOMAIN" &>/dev/null; then
    echo "Domain does not resolve"
    exit 1
fi

# Use functions for reusability
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Handle errors gracefully
if ! command -v tool &>/dev/null; then
    log "Tool not found, skipping..."
    return 0
fi
```

#### Python
```python
# Follow PEP 8
# Use type hints where helpful
def start_scan(domain: str, scan_type: str) -> dict:
    """Start a new scan"""
    pass

# Use docstrings
def process_results(scan_id):
    """
    Process scan results and generate JSON output.
    
    Args:
        scan_id: Unique identifier for the scan
        
    Returns:
        dict: Processed results with findings
    """
    pass

# Handle exceptions
try:
    result = risky_operation()
except Exception as e:
    logger.error(f"Operation failed: {e}")
    return {"error": str(e)}
```

#### JavaScript
```javascript
// Use modern ES6+ features
const fetchScanStatus = async (scanId) => {
    try {
        const response = await fetch(`/api/scan/${scanId}`);
        return await response.json();
    } catch (error) {
        console.error('Failed to fetch scan status:', error);
        return null;
    }
};

// Use descriptive names
const startNewScan = (domain, scanType) => {
    // Implementation
};

// Add comments for complex logic
// Poll every 2 seconds until scan completes
const pollInterval = setInterval(() => {
    updateScanStatus(scanId);
}, 2000);
```

### Testing

#### Test Your Changes
```bash
# Test web interface
./test_web.sh

# Test CLI
./garudrecon -h
./cmd/scan_light -h

# Test scans (use your own domain)
./cmd/scan_light -d yourdomain.com -o test-output/
```

#### Manual Testing Checklist
- [ ] Web interface loads correctly
- [ ] Can start a scan
- [ ] Progress updates in real-time
- [ ] Results display properly
- [ ] Download works
- [ ] CLI commands work
- [ ] No errors in console
- [ ] Mobile responsive

## 🐛 Bug Reports

### Good Bug Report Template
```markdown
**Description**
Clear description of the bug

**Steps to Reproduce**
1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: Ubuntu 24.04
- Python: 3.10
- Browser: Chrome 120

**Logs**
```
Paste relevant logs here
```

**Screenshots**
If applicable
```

## ✨ Feature Requests

### Good Feature Request Template
```markdown
**Feature Description**
Clear description of the feature

**Use Case**
Why is this feature needed?

**Proposed Solution**
How should it work?

**Alternatives Considered**
Other approaches you thought about

**Additional Context**
Any other relevant information
```

## 🔨 Adding a New Tool

### Example: Adding a New Subdomain Tool

1. **Update Scan Script** (`cmd/scan_cool`):
```bash
# Add tool execution
if command -v newtool &> /dev/null; then
    log "Running newtool..."
    newtool -d "$DOMAIN" -o "$OUTPUT_DIR/newtool.txt" 2>/dev/null
    cat "$OUTPUT_DIR/newtool.txt" >> "$SUBDOMAINS_FILE"
fi
```

2. **Update Install Script** (`cmd/install`):
```bash
# Add installation logic
install_newtool() {
    log "Installing newtool..."
    go install github.com/author/newtool@latest
}
```

3. **Test**:
```bash
./cmd/scan_cool -d example.com -o test/
```

4. **Document**:
- Add to FEATURES.md
- Add to WEB_INTERFACE.md
- Update README.md if needed

## 🎨 Adding UI Features

### Example: Adding a New Scan Mode

1. **Backend** (`web_backend.py`):
```python
script_map = {
    'light': './cmd/scan_light',
    'cool': './cmd/scan_cool',
    'ultra': './cmd/scan_ultra',
    'custom': './cmd/scan_custom'  # New mode
}
```

2. **Frontend** (`web/index.html`):
```html
<div class="scan-type-option">
    <input type="radio" id="custom" name="scan_type" value="custom">
    <label for="custom" class="scan-type-label">
        <div class="scan-type-icon">⭐</div>
        <div class="scan-type-name">Custom</div>
        <div class="scan-type-desc">Your custom scan mode</div>
        <div class="scan-type-time">~X minutes</div>
    </label>
</div>
```

3. **Create Script** (`cmd/scan_custom`):
```bash
#!/bin/bash
# Your custom scan implementation
```

## 📝 Documentation

### When to Update Documentation

- Adding features → Update FEATURES.md, WEB_INTERFACE.md
- Fixing bugs → Update CHANGELOG.md
- Adding examples → Update EXAMPLES.md
- Changing API → Update WEB_INTERFACE.md
- New tools → Update README.md

### Documentation Style

- Clear and concise
- Include code examples
- Add screenshots when helpful
- Keep formatting consistent
- Test all commands/examples

## 🔄 Pull Request Process

### 1. Before Submitting

- [ ] Code follows style guidelines
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No unnecessary files included
- [ ] Commit messages are clear

### 2. PR Template

```markdown
**Description**
What does this PR do?

**Type of Change**
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

**Testing**
How was this tested?

**Checklist**
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] No breaking changes

**Screenshots**
If applicable
```

### 3. After Submitting

- Respond to review comments
- Make requested changes
- Keep PR updated with main branch

## 🏗️ Architecture

### Backend Flow
```
User Request
    ↓
Flask API (/api/scan)
    ↓
Background Thread
    ↓
Execute Scan Script (bash)
    ↓
Generate Results (JSON)
    ↓
Return to User
```

### Scan Script Flow
```
Parse Arguments
    ↓
Initialize Output
    ↓
Run Tools (parallel when possible)
    ↓
Aggregate Results
    ↓
Generate JSON
    ↓
Write Summary
```

### Frontend Flow
```
User Input
    ↓
Submit to API
    ↓
Receive Scan ID
    ↓
Poll for Status
    ↓
Display Results
    ↓
Allow Download
```

## 🎓 Learning Resources

### Understanding the Codebase
1. Start with `garudrecon` (main entry)
2. Read `web_backend.py` (API logic)
3. Study `cmd/scan_light` (simplest scan)
4. Explore `web/script.js` (frontend logic)

### Security Tools
- Learn about each integrated tool
- Read tool documentation
- Understand what each tool does
- Know when to use each tool

## 🤝 Community

### Communication
- GitHub Issues: Bug reports, features
- GitHub Discussions: Questions, ideas
- Pull Requests: Code contributions

### Code of Conduct
- Be respectful and professional
- Help others learn
- Accept constructive feedback
- Focus on what's best for the project

## 📋 Checklist for Contributors

### First Time
- [ ] Fork repository
- [ ] Clone locally
- [ ] Set up dev environment
- [ ] Run tests
- [ ] Read documentation
- [ ] Find an issue to work on

### Every Contribution
- [ ] Create feature branch
- [ ] Make changes
- [ ] Test thoroughly
- [ ] Update documentation
- [ ] Commit with clear messages
- [ ] Push to your fork
- [ ] Create pull request
- [ ] Address review comments

## 🙏 Thank You!

Every contribution, no matter how small, makes GarudRecon better. We appreciate your time and effort!

---

**Questions?** Feel free to open an issue or discussion.

**Ready to contribute?** Pick an issue and get started!

**Happy Coding! 🚀**
