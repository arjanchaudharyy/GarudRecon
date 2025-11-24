#!/usr/bin/env python3

# CTXREC - Advanced Reconnaissance & Vulnerability Scanner
# Created by: arjanchaudharyy
# GitHub: https://github.com/arjanchaudharyy/GarudRecon

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import subprocess
import threading
import uuid
import json
import os
import time
from datetime import datetime
from pathlib import Path
import shutil
import sys
import platform

# Fix Windows console encoding for Unicode characters
if platform.system() == 'Windows':
    try:
        # Set UTF-8 encoding for Windows console
        if sys.stdout.encoding != 'utf-8':
            sys.stdout.reconfigure(encoding='utf-8')
        if sys.stderr.encoding != 'utf-8':
            sys.stderr.reconfigure(encoding='utf-8')
    except Exception:
        # If reconfigure fails, we'll use ASCII fallbacks
        pass

# Platform detection
IS_WINDOWS = platform.system() == 'Windows'
IS_LINUX = platform.system() == 'Linux'
IS_MAC = platform.system() == 'Darwin'

# Check for WSL availability on Windows
HAS_WSL = False
if IS_WINDOWS:
    try:
        # Check if wsl command works and has distributions
        # wsl --list lists distributions. If none, it prints a message.
        result = subprocess.run(['wsl', '--list'], capture_output=True, timeout=3)
        
        if result.returncode == 0:
            # Try to decode output to check for "no installed distributions" message
            # WSL often uses UTF-16LE for output
            try:
                output = result.stdout.decode('utf-16le')
            except UnicodeDecodeError:
                output = result.stdout.decode('utf-8', errors='ignore')
            
            # Check for common error messages indicating no distro
            if "no installed distributions" not in output and "has no installed distributions" not in output:
                HAS_WSL = True
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    except Exception:
        pass

app = Flask(__name__, static_folder='web', static_url_path='')
CORS(app)

# Create necessary directories
SCANS_DIR = Path("scans")
SCANS_DIR.mkdir(exist_ok=True)

# Store active scans in memory
active_scans = {}
scan_results = {}

# Auto-install tools on startup
def auto_install_tools():
    """Check tool availability and provide deployment info"""
    try:
        print("\n" + "="*60)
        print("CTXREC - Checking tool availability...")
        print("="*60)
        
        # Windows platform warning
        if IS_WINDOWS:
            print("\n[!] WARNING: Running on Windows")
            if HAS_WSL:
                print("[+] WSL detected - scans will run through WSL")
            else:
                print("[!] WSL not detected - GarudRecon requires Linux environment")
                print("[!] Please install WSL: https://docs.microsoft.com/windows/wsl/install")
                print("[!] Or use Docker: docker run -p 5000:5000 garudrecon")
                print("\n[i] Web interface will start, but scans will fail without WSL/Docker\n")
                return
        
        # Check if running in Docker/Railway (tools should be pre-installed)
        in_docker = os.path.exists('/.dockerenv') or os.environ.get('RAILWAY_ENVIRONMENT')
        
        essential_tools = ['dig', 'nmap', 'curl', 'httpx', 'subfinder', 'nuclei']
        found_tools = []
        missing_tools = []
        
        for tool in essential_tools:
            if shutil.which(tool):
                found_tools.append(tool)
            else:
                missing_tools.append(tool)
        
        if missing_tools:
            print(f"\n[!] Missing tools: {', '.join(missing_tools)}")
            
            if in_docker:
                print("\n[*] Running in containerized environment (Docker/Railway)")
                print("[!] Tools should be pre-installed in the Docker image.")
                print("If tools are missing, the Docker build may have failed.")
                print("Please check the build logs on Railway dashboard.\n")
                print("Expected tools location:")
                print(f"  - System tools: /usr/bin/")
                print(f"  - Go tools: {os.environ.get('GOPATH', '/root/go')}/bin/")
                print(f"  - Current PATH: {os.environ.get('PATH', 'Not set')}\n")
            else:
                print("\n[*] To install missing tools, run:")
                print("  sudo ./install_basic_tools.sh")
                print("or for full installation:")
                print("  ./garudrecon install -f ALL\n")
        else:
            print("\n[+] All essential tools are installed!")
            print(f"[+] Found: {', '.join(found_tools)}\n")
            
        if found_tools:
            print(f"[+] Available tools ({len(found_tools)}/{len(essential_tools)}): {', '.join(found_tools)}")
    except Exception as e:
        # Catch any encoding or other errors gracefully
        print(f"\n[!] Error checking tools: {str(e)}")
        print("[i] Web interface will continue to start...")

# Check for essential tools
def check_tools():
    """Check which essential tools are available"""
    essential_tools = {
        'light': ['dig', 'curl'],
        'cool': ['subfinder', 'httpx', 'dnsx'],
        'ultra': ['subfinder', 'httpx', 'nuclei', 'naabu']
    }
    
    available_tools = {}
    for scan_type, tools in essential_tools.items():
        available_tools[scan_type] = []
        for tool in tools:
            if shutil.which(tool):
                available_tools[scan_type].append(tool)
    
    return available_tools

def run_scan(scan_id, domain, scan_type):
    """Execute scan in background thread"""
    try:
        active_scans[scan_id]['status'] = 'running'
        active_scans[scan_id]['start_time'] = datetime.now().isoformat()
        
        # Platform-specific error handling
        if IS_WINDOWS and not HAS_WSL:
            error_msg = "GarudRecon requires Linux environment. Please install WSL or use Docker."
            active_scans[scan_id]['status'] = 'failed'
            active_scans[scan_id]['error'] = error_msg
            active_scans[scan_id]['log'] = [
                "ERROR: Running on Windows without WSL",
                "GarudRecon scan scripts require a Linux environment.",
                "",
                "Solutions:",
                "1. Install WSL: https://docs.microsoft.com/windows/wsl/install",
                "2. Use Docker: docker run -p 5000:5000 garudrecon",
                "3. Deploy to Railway/cloud: https://railway.app",
                "",
                f"Error: {error_msg}"
            ]
            active_scans[scan_id]['end_time'] = datetime.now().isoformat()
            return
        
        # Determine which script to run based on scan type
        script_map = {
            'light': './cmd/scan_light',
            'cool': './cmd/scan_cool',
            'ultra': './cmd/scan_ultra'
        }
        
        script = script_map.get(scan_type)
        if not script:
            raise ValueError(f"Invalid scan type: {scan_type}")
        
        # Create output directory for this scan
        scan_output_dir = SCANS_DIR / scan_id
        scan_output_dir.mkdir(exist_ok=True)
        
        # Run the scan
        active_scans[scan_id]['log'] = []
        
        # Prepare command based on platform
        if IS_WINDOWS and HAS_WSL:
            # Convert Windows path to WSL path
            wsl_dir = str(scan_output_dir).replace('\\', '/')
            # Run through WSL
            cmd = ['wsl', 'bash', script, '-d', domain, '-o', wsl_dir]
            active_scans[scan_id]['log'].append(f"Running on Windows via WSL: {' '.join(cmd)}")
        else:
            # Linux/Mac: run directly
            cmd = [script, '-d', domain, '-o', str(scan_output_dir)]
        
        process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True,
            bufsize=1
        )
        
        # Stream output
        for line in process.stdout:
            line = line.strip()
            if line:
                active_scans[scan_id]['log'].append(line)
                active_scans[scan_id]['last_update'] = datetime.now().isoformat()
        
        process.wait()
        
        # Scan completed
        if process.returncode == 0:
            active_scans[scan_id]['status'] = 'completed'
            active_scans[scan_id]['end_time'] = datetime.now().isoformat()
            
            # Load results
            result_file = scan_output_dir / 'results.json'
            if result_file.exists():
                try:
                    with open(result_file) as f:
                        scan_results[scan_id] = json.load(f)
                except json.JSONDecodeError as e:
                    active_scans[scan_id]['status'] = 'failed'
                    active_scans[scan_id]['error'] = f"JSON parse error: {str(e)}"
                    active_scans[scan_id]['log'].append(f"ERROR: {str(e)}")
                    scan_results[scan_id] = {
                        'message': 'Scan completed but results file is invalid',
                        'error': str(e)
                    }
            else:
                scan_results[scan_id] = {
                    'message': 'Scan completed but no results file found',
                    'log': active_scans[scan_id]['log']
                }
        else:
            active_scans[scan_id]['status'] = 'failed'
            active_scans[scan_id]['error'] = f"Scan failed with exit code {process.returncode}"
            
    except Exception as e:
        active_scans[scan_id]['status'] = 'failed'
        active_scans[scan_id]['error'] = str(e)
        active_scans[scan_id]['end_time'] = datetime.now().isoformat()

@app.route('/')
def index():
    """Serve the main HTML page"""
    return send_from_directory('web', 'index.html')

@app.route('/api/scan', methods=['POST'])
def start_scan():
    """Start a new scan"""
    data = request.get_json()
    
    domain = data.get('domain', '').strip()
    scan_type = data.get('scan_type', 'light').lower()
    
    # Validate input
    if not domain:
        return jsonify({'error': 'Domain is required'}), 400
    
    if scan_type not in ['light', 'cool', 'ultra']:
        return jsonify({'error': 'Invalid scan type. Must be: light, cool, or ultra'}), 400
    
    # Create scan ID
    scan_id = str(uuid.uuid4())
    
    # Initialize scan metadata
    active_scans[scan_id] = {
        'scan_id': scan_id,
        'domain': domain,
        'scan_type': scan_type,
        'status': 'queued',
        'created_at': datetime.now().isoformat(),
        'log': []
    }
    
    # Start scan in background thread
    thread = threading.Thread(target=run_scan, args=(scan_id, domain, scan_type))
    thread.daemon = True
    thread.start()
    
    return jsonify({
        'scan_id': scan_id,
        'domain': domain,
        'scan_type': scan_type,
        'status': 'queued'
    }), 202

@app.route('/api/scan/<scan_id>', methods=['GET'])
def get_scan_status(scan_id):
    """Get scan status and results"""
    if scan_id not in active_scans:
        return jsonify({'error': 'Scan not found'}), 404
    
    scan_info = active_scans[scan_id].copy()
    
    # Include results if available
    if scan_id in scan_results:
        scan_info['results'] = scan_results[scan_id]
    
    return jsonify(scan_info)

@app.route('/api/scans', methods=['GET'])
def list_scans():
    """List all scans"""
    scans_list = []
    for scan_id, scan_info in active_scans.items():
        scans_list.append({
            'scan_id': scan_id,
            'domain': scan_info['domain'],
            'scan_type': scan_info['scan_type'],
            'status': scan_info['status'],
            'created_at': scan_info['created_at']
        })
    
    # Sort by created_at descending
    scans_list.sort(key=lambda x: x['created_at'], reverse=True)
    
    return jsonify({'scans': scans_list})

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint - lightweight for Railway deployment"""
    try:
        # Quick health check without expensive tool scanning
        # Tool checking is done in /api/tools endpoint instead
        return jsonify({
            'status': 'healthy', 
            'message': 'GarudRecon Web API is running',
            'version': '2.0'
        }), 200
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'error': str(e)
        }), 503

@app.route('/api/tools', methods=['GET'])
def get_tools():
    """Get available tools status"""
    tools = check_tools()
    return jsonify({
        'available_tools': tools,
        'recommendations': {
            'light': 'Install: dig, nmap, httpx, waybackurls',
            'cool': 'Install: subfinder, httpx, dnsx, naabu, nuclei',
            'ultra': 'Run: ./garudrecon install -f ALL'
        }
    })

@app.route('/api/scan/<scan_id>/files', methods=['GET'])
def list_scan_files(scan_id):
    """List all files in a scan directory"""
    if scan_id not in active_scans:
        return jsonify({'error': 'Scan not found'}), 404
    
    scan_dir = SCANS_DIR / scan_id
    if not scan_dir.exists():
        return jsonify({'files': []})
    
    files = []
    for file_path in scan_dir.glob('*.txt'):
        file_stat = file_path.stat()
        files.append({
            'name': file_path.name,
            'size': file_stat.st_size,
            'lines': sum(1 for _ in open(file_path)) if file_stat.st_size > 0 else 0
        })
    
    return jsonify({'files': files})

@app.route('/api/scan/<scan_id>/file/<filename>', methods=['GET'])
def get_scan_file(scan_id, filename):
    """Get contents of a specific scan file"""
    if scan_id not in active_scans:
        return jsonify({'error': 'Scan not found'}), 404
    
    scan_dir = SCANS_DIR / scan_id
    file_path = scan_dir / filename
    
    if not file_path.exists() or not file_path.is_file():
        return jsonify({'error': 'File not found'}), 404
    
    # Security check: ensure file is within scan directory
    if not str(file_path.resolve()).startswith(str(scan_dir.resolve())):
        return jsonify({'error': 'Invalid file path'}), 403
    
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        return jsonify({
            'filename': filename,
            'content': content,
            'lines': len(content.split('\n'))
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Get port from environment (for Railway/cloud deployments) or default to 5000
    port = int(os.environ.get('PORT', 5000))
    
    print("=" * 60)
    print("CTXREC Web Interface")
    print("Created by: arjanchaudharyy")
    print("=" * 60)
    print(f"\nStarting server on http://0.0.0.0:{port}")
    print("\nScan Types Available:")
    print("  - Light: Simple recon and vulnerability scan")
    print("  - Cool:  Medium-level comprehensive scan")
    print("  - Ultra: Full-scale deep reconnaissance")
    print("\n" + "=" * 60)
    
    # Auto-install tools in background thread (non-blocking)
    # This prevents blocking the health check endpoint during Railway deployment
    install_thread = threading.Thread(target=auto_install_tools, daemon=True)
    install_thread.start()
    
    app.run(host='0.0.0.0', port=port, debug=False, threaded=True)
