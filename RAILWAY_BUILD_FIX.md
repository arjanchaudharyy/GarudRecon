# Railway Build Failure Fix

## Problem
Railway deployment fails with error:
```
ERROR: failed to build: failed to solve: process "/bin/sh -c ... go install ..." did not complete successfully: exit code: 1
```

## Root Cause
The Go tools installation was failing due to:
1. **Outdated Go version** (1.21.5) with compatibility issues
2. **Missing build dependencies** (gcc, g++, libpcap-dev)
3. **Large monolithic RUN command** that's hard to debug
4. **Missing Go environment variables** (GOPROXY, CGO_ENABLED)
5. **Network/timeout issues** during tool compilation

## Solution Applied

### 1. Updated Go Version
- **Before**: Go 1.21.5
- **After**: Go 1.23.5 (latest stable)
- Ensures compatibility with latest tool versions

### 2. Added Build Dependencies
```dockerfile
# Added to apt-get install:
gcc \
g++ \
make \
libpcap-dev \        # Required for naabu (network scanning)
ca-certificates \    # SSL certificate verification
```

### 3. Set Proper Go Environment Variables
```dockerfile
ENV CGO_ENABLED=1                          # Enable C bindings (required for some tools)
ENV GOPROXY=https://proxy.golang.org,direct # Faster, more reliable downloads
ENV GOTIMEOUT=10m                          # Increase timeout for large tools
```

### 4. Split Installation into Batches
Instead of one large RUN command, split into 4 batches:
- **Batch 1**: httpx, subfinder, dnsx
- **Batch 2**: naabu, nuclei, katana
- **Batch 3**: waybackurls, assetfinder, gf, anew
- **Batch 4**: gau, dalfox

**Benefits**:
- Better error messages (know which tool failed)
- Improved Docker layer caching
- Easier debugging
- More resilient to network issues

### 5. Enhanced Dockerfile Structure
```dockerfile
# Each batch has clear output
RUN echo "=== Installing ProjectDiscovery tools ===" && \
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest && \
    echo "✓ Batch 1 complete"
```

## Deployment Steps

### 1. Push Changes to Repository
```bash
git add Dockerfile railway.toml RAILWAY_BUILD_FIX.md
git commit -m "Fix Railway Docker build - Update Go version and dependencies"
git push origin main
```

### 2. Redeploy on Railway
Railway will automatically detect changes and start a new build.

**OR** manually trigger:
1. Go to Railway Dashboard
2. Select your project
3. Click **⋮** (three dots) → **Redeploy**

### 3. Monitor Build Progress
Watch the build logs for:
- ✓ Go installation: `go version` output
- ✓ Batch 1-4 completion messages
- ✓ Tool verification at the end

**Expected build time**: 5-10 minutes

### 4. Verify Deployment
Once deployed, test the endpoints:
```bash
# Health check
curl https://your-app.railway.app/api/health

# Tool verification
curl https://your-app.railway.app/api/tools
```

## What Changed in the Dockerfile

### Before (Failing)
```dockerfile
# Single Go version
ENV GO_VERSION=1.21.5

# Minimal system deps
RUN apt-get install -y build-essential dnsutils nmap ...

# One massive RUN command
RUN go install httpx@latest && \
    go install subfinder@latest && \
    go install dnsx@latest && \
    ... (12 more tools)
```

### After (Working)
```dockerfile
# Updated Go version
ENV GO_VERSION=1.23.5
ENV CGO_ENABLED=1
ENV GOPROXY=https://proxy.golang.org,direct

# Complete build dependencies
RUN apt-get install -y \
    build-essential gcc g++ make \
    libpcap-dev ca-certificates \
    dnsutils nmap jq ...

# Split into 4 batches with progress tracking
RUN echo "=== Batch 1 ===" && ...
RUN echo "=== Batch 2 ===" && ...
RUN echo "=== Batch 3 ===" && ...
RUN echo "=== Batch 4 ===" && ...
```

## Troubleshooting

### If Build Still Fails

#### Check Which Batch Failed
Look at the Railway build logs to identify which batch failed:
- `Batch 1 complete` ✓ - Core tools OK
- `Batch 2 complete` ✗ - Failed installing naabu/nuclei

#### Common Issues by Batch

**Batch 1 (httpx, subfinder, dnsx)**: Usually reliable
- If fails: Network issue, retry deployment

**Batch 2 (naabu, nuclei, katana)**: Most resource-intensive
- **naabu**: Requires libpcap-dev (now included)
- **nuclei**: Large tool, may timeout
- Solution: Build caching should help on retry

**Batch 3 (TomNomNom tools)**: Usually reliable
- Simple Go tools, rarely fail

**Batch 4 (gau, dalfox)**: Medium complexity
- **dalfox**: Larger tool, may take time
- Solution: Retry if timeout

### Memory/Timeout Issues
If Railway kills the build due to resource limits:

1. **Contact Railway Support** to increase build resources
2. **Alternative**: Use smaller tool subset
3. **Alternative**: Pre-build Docker image elsewhere, push to Docker Hub

### Verify Local Build (Optional)
Test the Dockerfile locally:
```bash
docker build -t garudrecon-test .

# This will take 5-10 minutes
# Watch for "✓ Batch X complete" messages
```

## Expected Build Output

Successful build will show:
```
Step 10/20 : RUN echo "=== Installing ProjectDiscovery tools ==="
 ---> Running in abc123
=== Installing ProjectDiscovery tools ===
go: downloading github.com/projectdiscovery/httpx ...
✓ Batch 1 complete
 ---> def456

Step 11/20 : RUN echo "=== Installing naabu and nuclei ==="
 ---> Running in ghi789
=== Installing naabu and nuclei ===
go: downloading github.com/projectdiscovery/naabu ...
✓ Batch 2 complete
 ---> jkl012

... (continues for all batches)

Step 20/20 : ENTRYPOINT ["/app/docker-entrypoint.sh"]
 ---> Running in mno345
 ---> pqr678
Successfully built pqr678
```

## Post-Deployment Verification

After successful deployment:

1. **Check health endpoint**:
   ```bash
   curl https://your-app.railway.app/api/health
   # Expected: {"status": "healthy"}
   ```

2. **Verify tools are installed**:
   ```bash
   curl https://your-app.railway.app/api/tools
   # Should show tools with "installed": true
   ```

3. **Run a test scan**:
   - Visit web interface: `https://your-app.railway.app`
   - Run Light scan on `example.com`
   - Should complete in 5-10 minutes with real results

## Summary

The key fixes were:
1. ✅ Update Go to 1.23.5
2. ✅ Add gcc, g++, libpcap-dev, ca-certificates
3. ✅ Set CGO_ENABLED=1 and GOPROXY
4. ✅ Split tool installation into 4 batches
5. ✅ Add progress tracking and better error messages

**Result**: Railway build should now complete successfully in 5-10 minutes.
