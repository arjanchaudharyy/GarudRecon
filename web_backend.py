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
    """Automatically install missing tools on first run"""
    print("\n" + "="*60)
    print("CTXREC - Checking tool availability...")
    print("="*60)
    
    essential_tools = ['dig', 'nmap', 'curl', 'httpx', 'subfinder', 'nuclei']
    missing_tools = []
    
    for tool in essential_tools:
        if not shutil.which(tool):
            missing_tools.append(tool)
    
    if missing_tools:
        print(f"\n⚠️  Missing tools detected: {', '.join(missing_tools)}")
        print("\n🔧 Starting automatic tool installation...")
        print("This may take 5-15 minutes depending on your system.\n")
        
        # Run auto-installer
        installer_path = Path(__file__).parent / "auto_install_tools.sh"
        if installer_path.exists():
            try:
                # Run installer in background
                result = subprocess.run(
                    ["bash", str(installer_path)],
                    capture_output=True,
                    text=True,
                    timeout=900  # 15 minute timeout
                )
                
                if result.returncode == 0:
                    print("\n✅ Tool installation completed successfully!")
                    print("Restarting PATH configuration...\n")
                    
                    # Add Go bin to PATH for current session
                    go_bin = os.path.expanduser("~/go/bin")
                    if go_bin not in os.environ.get('PATH', ''):
                        os.environ['PATH'] = f"{os.environ.get('PATH', '')}:{go_bin}:/usr/local/go/bin"
                else:
                    print(f"\n⚠️  Auto-installation encountered issues.")
                    print("You can manually install tools using:")
                    print("  sudo ./install_basic_tools.sh")
                    print("\nContinuing with available tools...\n")
            except subprocess.TimeoutExpired:
                print("\n⚠️  Installation timed out. Continuing with available tools...\n")
            except Exception as e:
                print(f"\n⚠️  Auto-installation failed: {e}")
                print("You can manually install tools using:")
                print("  sudo ./install_basic_tools.sh\n")
        else:
            print("⚠️  Auto-installer not found. Please run:")
            print("  sudo ./install_basic_tools.sh\n")
    else:
        print("\n✅ All essential tools are installed!")
        print(f"✓ Found: {', '.join(essential_tools)}\n")

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
        
        process = subprocess.Popen(
            [script, '-d', domain, '-o', str(scan_output_dir)],
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
