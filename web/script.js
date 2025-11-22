const API_BASE = window.location.origin;
let currentScanId = null;
let pollInterval = null;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadRecentScans();
    setupEventListeners();
    checkToolStatus();
});

function setupEventListeners() {
    const scanForm = document.getElementById('scanForm');
    scanForm.addEventListener('submit', handleScanSubmit);
}

async function checkToolStatus() {
    try {
        const response = await fetch(`${API_BASE}/api/tools`);
        const data = await response.json();
        
        // Show tool status banner if tools are missing
        const availableCount = Object.values(data.available_tools).reduce((sum, tools) => sum + tools.length, 0);
        if (availableCount < 5) {
            showToolWarning();
        }
    } catch (error) {
        console.error('Error checking tools:', error);
    }
}

function showToolWarning() {
    const banner = document.createElement('div');
    banner.className = 'tool-warning-banner';
    banner.innerHTML = `
        <strong>⚠️ Warning:</strong> Some reconnaissance tools are not installed. 
        Results may be limited. Run <code>sudo ./start_web.sh</code> to auto-install tools.
    `;
    document.querySelector('.container').insertBefore(banner, document.querySelector('header').nextSibling);
}

async function handleScanSubmit(e) {
    e.preventDefault();
    
    let domain = document.getElementById('domain').value.trim();
    const scanType = document.querySelector('input[name="scan_type"]:checked').value;
    
    // Strip protocol and trailing slashes from domain
    domain = domain.replace(/^(https?:\/\/)?(www\.)?/, '').replace(/\/+$/, '');
    
    // Validate domain
    if (!domain) {
        alert('Please enter a domain');
        return;
    }
    
    // Disable submit button
    const submitBtn = document.getElementById('startScanBtn');
    submitBtn.disabled = true;
    submitBtn.textContent = 'Starting Scan...';
    
    try {
        const response = await fetch(`${API_BASE}/api/scan`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                domain: domain,
                scan_type: scanType
            })
        });
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.error || 'Failed to start scan');
        }
        
        const data = await response.json();
        currentScanId = data.scan_id;
        
        // Show progress card
        showScanProgress(data);
        
        // Start polling for updates
        startPolling(data.scan_id);
        
        // Reset form
        document.getElementById('scanForm').reset();
        
    } catch (error) {
        alert(`Error: ${error.message}`);
        console.error('Scan error:', error);
    } finally {
        submitBtn.disabled = false;
        submitBtn.textContent = 'Start Scan';
    }
}

function showScanProgress(scanData) {
    const progressCard = document.getElementById('scanProgressCard');
    progressCard.style.display = 'block';
    
    document.getElementById('scanId').textContent = scanData.scan_id;
    document.getElementById('scanDomain').textContent = scanData.domain;
    document.getElementById('scanType').textContent = scanData.scan_type.toUpperCase();
    updateStatus(scanData.status);
    
    // Clear log
    document.getElementById('logOutput').innerHTML = '<div class="log-line">Initializing scan...</div>';
    
    // Reset progress bar
    document.getElementById('progressBar').style.width = '10%';
    
    // Hide results card
    document.getElementById('scanResultsCard').style.display = 'none';
    
    // Scroll to progress card
    progressCard.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function updateStatus(status) {
    const statusSpan = document.getElementById('scanStatus');
    statusSpan.textContent = status.toUpperCase();
    statusSpan.className = `status-badge ${status}`;
}

function startPolling(scanId) {
    // Clear existing interval
    if (pollInterval) {
        clearInterval(pollInterval);
    }
    
    // Poll every 2 seconds
    pollInterval = setInterval(() => {
        updateScanStatus(scanId);
    }, 2000);
    
    // Initial update
    updateScanStatus(scanId);
}

async function updateScanStatus(scanId) {
    try {
        const response = await fetch(`${API_BASE}/api/scan/${scanId}`);
        
        if (!response.ok) {
            throw new Error('Failed to fetch scan status');
        }
        
        const data = await response.json();
        
        // Update status
        updateStatus(data.status);
        
        // Update progress bar
        const progressBar = document.getElementById('progressBar');
        if (data.status === 'queued') {
            progressBar.style.width = '10%';
        } else if (data.status === 'running') {
            progressBar.style.width = '50%';
        } else if (data.status === 'completed') {
            progressBar.style.width = '100%';
        } else if (data.status === 'failed') {
            progressBar.style.width = '100%';
            progressBar.style.background = 'var(--danger-color)';
        }
        
        // Update log
        if (data.log && data.log.length > 0) {
            const logOutput = document.getElementById('logOutput');
            logOutput.innerHTML = data.log
                .map(line => formatLogLine(line))
                .join('');
            
            // Auto-scroll to bottom
            logOutput.scrollTop = logOutput.scrollHeight;
        }
        
        // Handle completion
        if (data.status === 'completed' || data.status === 'failed') {
            clearInterval(pollInterval);
            pollInterval = null;
            
            if (data.status === 'completed') {
                showResults(data);
            } else {
                const logOutput = document.getElementById('logOutput');
                const errorMsg = data.error || 'Scan failed';
                logOutput.innerHTML += `<div class="log-line error">ERROR: ${escapeHtml(errorMsg)}</div>`;
            }
            
            // Reload recent scans
            loadRecentScans();
        }
        
    } catch (error) {
        console.error('Error updating scan status:', error);
    }
}

function formatLogLine(line) {
    let className = 'log-line';
    let icon = '';
    
    // Detect log type and add appropriate styling
    if (line.includes('ERROR') || line.includes('error') || line.includes('failed')) {
        className += ' error';
        icon = '❌ ';
    } else if (line.includes('WARNING') || line.includes('warning') || line.includes('Skipping')) {
        className += ' warning';
        icon = '⚠️ ';
    } else if (line.includes('✓') || line.includes('complete') || line.includes('Found')) {
        className += ' success';
        icon = '✓ ';
    } else if (line.includes('[') && line.includes(']')) {
        // Step indicators
        className += ' step';
        icon = '▶ ';
    }
    
    // Highlight tool names
    const toolNames = ['httpx', 'subfinder', 'nuclei', 'nmap', 'dig', 'waybackurls', 'dalfox', 'sqlmap', 'dnsx', 'naabu', 'katana', 'gau'];
    let formattedLine = escapeHtml(line);
    
    toolNames.forEach(tool => {
        const regex = new RegExp(`\\b${tool}\\b`, 'gi');
        formattedLine = formattedLine.replace(regex, `<span class="tool-name">${tool}</span>`);
    });
    
    return `<div class="${className}">${icon}${formattedLine}</div>`;
}

async function showResults(scanData) {
    const resultsCard = document.getElementById('scanResultsCard');
    const resultsDiv = document.getElementById('scanResults');
    
    if (!scanData.results) {
        resultsDiv.innerHTML = '<p class="text-muted">No results available.</p>';
        resultsCard.style.display = 'block';
        return;
    }
    
    const results = scanData.results;
    const findings = results.findings || {};
    
    // Build structured results HTML
    let html = `
        <div class="results-summary">
            <div class="summary-card">
                <div class="summary-icon">🌐</div>
                <div class="summary-value">${findings.dns_records || 0}</div>
                <div class="summary-label">DNS Records</div>
            </div>
            <div class="summary-card">
                <div class="summary-icon">🔌</div>
                <div class="summary-value">${findings.open_ports || 0}</div>
                <div class="summary-label">Open Ports</div>
            </div>
            <div class="summary-card">
                <div class="summary-icon">🔗</div>
                <div class="summary-value">${findings.urls_found || 0}</div>
                <div class="summary-label">URLs Found</div>
            </div>
            <div class="summary-card">
                <div class="summary-icon">⚠️</div>
                <div class="summary-value">${findings.xss_findings || 0}</div>
                <div class="summary-label">XSS Issues</div>
            </div>
            <div class="summary-card">
                <div class="summary-icon">💉</div>
                <div class="summary-value">${findings.sqli_findings || 0}</div>
                <div class="summary-label">SQLi Issues</div>
            </div>
            ${findings.subdomains ? `
            <div class="summary-card">
                <div class="summary-icon">🔎</div>
                <div class="summary-value">${findings.subdomains}</div>
                <div class="summary-label">Subdomains</div>
            </div>
            ` : ''}
            ${findings.nuclei_findings ? `
            <div class="summary-card">
                <div class="summary-icon">🔥</div>
                <div class="summary-value">${findings.nuclei_findings}</div>
                <div class="summary-label">Nuclei Findings</div>
            </div>
            ` : ''}
        </div>
    `;
    
    // Add detailed findings sections
    html += '<div class="findings-sections">';
    
    // Load and display file contents
    try {
        const filesResponse = await fetch(`${API_BASE}/api/scan/${scanData.scan_id}/files`);
        const filesData = await filesResponse.json();
        
        if (filesData.files && filesData.files.length > 0) {
            html += '<div class="findings-section"><h3>📁 Generated Files</h3><div class="file-list">';
            
            for (const file of filesData.files) {
                if (file.lines > 0) {
                    html += `
                        <div class="file-item" onclick="viewFile('${scanData.scan_id}', '${file.name}')">
                            <div class="file-name">📄 ${file.name}</div>
                            <div class="file-meta">${file.lines} lines</div>
                        </div>
                    `;
                }
            }
            
            html += '</div></div>';
        }
    } catch (error) {
        console.error('Error loading files:', error);
    }
    
    html += '</div>';
    
    // Download button
    html += `
        <div class="results-actions">
            <button class="btn btn-primary" onclick="downloadResults()">
                📥 Download Full Results (JSON)
            </button>
            <button class="btn btn-secondary" onclick="downloadAllFiles()">
                📦 Download All Files
            </button>
        </div>
    `;
    
    resultsDiv.innerHTML = html;
    resultsCard.style.display = 'block';
    resultsCard.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

async function viewFile(scanId, filename) {
    try {
        const response = await fetch(`${API_BASE}/api/scan/${scanId}/file/${filename}`);
        if (!response.ok) throw new Error('Failed to load file');
        
        const data = await response.json();
        
        // Create modal to show file content
        const modal = document.createElement('div');
        modal.className = 'modal';
        modal.innerHTML = `
            <div class="modal-content">
                <div class="modal-header">
                    <h3>📄 ${filename}</h3>
                    <button class="modal-close" onclick="this.closest('.modal').remove()">×</button>
                </div>
                <div class="modal-body">
                    <pre>${escapeHtml(data.content)}</pre>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" onclick="downloadFile('${scanId}', '${filename}')">
                        Download File
                    </button>
                    <button class="btn btn-secondary" onclick="this.closest('.modal').remove()">
                        Close
                    </button>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Close on background click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.remove();
            }
        });
    } catch (error) {
        alert(`Error viewing file: ${error.message}`);
    }
}

async function downloadFile(scanId, filename) {
    try {
        const response = await fetch(`${API_BASE}/api/scan/${scanId}/file/${filename}`);
        const data = await response.json();
        
        const blob = new Blob([data.content], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    } catch (error) {
        alert(`Error downloading file: ${error.message}`);
    }
}

async function loadRecentScans() {
    try {
        const response = await fetch(`${API_BASE}/api/scans`);
        
        if (!response.ok) {
            throw new Error('Failed to load recent scans');
        }
        
        const data = await response.json();
        displayRecentScans(data.scans);
        
    } catch (error) {
        console.error('Error loading recent scans:', error);
    }
}

function displayRecentScans(scans) {
    const container = document.getElementById('recentScans');
    
    if (!scans || scans.length === 0) {
        container.innerHTML = '<p class="text-muted">No recent scans</p>';
        return;
    }
    
    const table = document.createElement('table');
    table.innerHTML = `
        <thead>
            <tr>
                <th>Domain</th>
                <th>Type</th>
                <th>Status</th>
                <th>Started</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            ${scans.map(scan => `
                <tr>
                    <td>${escapeHtml(scan.domain)}</td>
                    <td>${escapeHtml(scan.scan_type.toUpperCase())}</td>
                    <td><span class="status-badge ${scan.status}">${escapeHtml(scan.status.toUpperCase())}</span></td>
                    <td>${formatDate(scan.created_at)}</td>
                    <td><a href="#" class="scan-link" onclick="viewScan('${scan.scan_id}'); return false;">View</a></td>
                </tr>
            `).join('')}
        </tbody>
    `;
    
    container.innerHTML = '';
    container.appendChild(table);
}

async function viewScan(scanId) {
    currentScanId = scanId;
    
    try {
        const response = await fetch(`${API_BASE}/api/scan/${scanId}`);
        
        if (!response.ok) {
            throw new Error('Failed to load scan');
        }
        
        const data = await response.json();
        
        showScanProgress({
            scan_id: data.scan_id,
            domain: data.domain,
            scan_type: data.scan_type,
            status: data.status
        });
        
        updateStatus(data.status);
        
        // Update log
        if (data.log && data.log.length > 0) {
            const logOutput = document.getElementById('logOutput');
            logOutput.innerHTML = data.log
                .map(line => formatLogLine(line))
                .join('');
        }
        
        // Update progress bar
        const progressBar = document.getElementById('progressBar');
        if (data.status === 'completed') {
            progressBar.style.width = '100%';
            showResults(data);
        } else if (data.status === 'failed') {
            progressBar.style.width = '100%';
            progressBar.style.background = 'var(--danger-color)';
        } else if (data.status === 'running') {
            progressBar.style.width = '50%';
            startPolling(scanId);
        }
        
    } catch (error) {
        alert(`Error: ${error.message}`);
        console.error('Error viewing scan:', error);
    }
}

function downloadResults() {
    if (!currentScanId) {
        alert('No scan selected');
        return;
    }
    
    fetch(`${API_BASE}/api/scan/${currentScanId}`)
        .then(response => response.json())
        .then(data => {
            const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `ctxrec-${data.domain}-${currentScanId}.json`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        })
        .catch(error => {
            alert(`Error downloading results: ${error.message}`);
            console.error('Download error:', error);
        });
}

function downloadAllFiles() {
    if (!currentScanId) {
        alert('No scan selected');
        return;
    }
    alert('Bulk download feature coming soon! For now, download individual files from the results section.');
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString();
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
