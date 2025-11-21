const API_BASE = window.location.origin;
let currentScanId = null;
let pollInterval = null;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadRecentScans();
    setupEventListeners();
});

function setupEventListeners() {
    const scanForm = document.getElementById('scanForm');
    scanForm.addEventListener('submit', handleScanSubmit);
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
                .map(line => `<div class="log-line">${escapeHtml(line)}</div>`)
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
                logOutput.innerHTML += `<div class="log-line" style="color: var(--danger-color); font-weight: bold;">ERROR: ${escapeHtml(errorMsg)}</div>`;
            }
            
            // Reload recent scans
            loadRecentScans();
        }
        
    } catch (error) {
        console.error('Error updating scan status:', error);
    }
}

function showResults(scanData) {
    const resultsCard = document.getElementById('scanResultsCard');
    const resultsDiv = document.getElementById('scanResults');
    
    if (scanData.results) {
        resultsDiv.innerHTML = `<pre>${JSON.stringify(scanData.results, null, 2)}</pre>`;
    } else {
        resultsDiv.innerHTML = '<p class="text-muted">Scan completed. Check the log for details.</p>';
    }
    
    resultsCard.style.display = 'block';
    resultsCard.scrollIntoView({ behavior: 'smooth', block: 'start' });
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
                .map(line => `<div class="log-line">${escapeHtml(line)}</div>`)
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
            a.download = `garudrecon-${data.domain}-${currentScanId}.json`;
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

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString();
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
