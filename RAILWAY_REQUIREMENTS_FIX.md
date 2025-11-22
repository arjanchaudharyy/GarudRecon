# Railway Deployment Fix: Missing requirements.txt

## Problem

Railway deployment was failing with this error:

```
ERROR: Could not open requirements file: [Errno 2] No such file or directory: 'requirements.txt'
```

Despite `requirements.txt` existing in the project and the Dockerfile having `COPY . /app/`, the file wasn't being copied into the Docker image.

## Root Cause

The `.dockerignore` file had a wildcard pattern that was excluding ALL `.txt` files:

```dockerignore
*.txt
```

This meant that `requirements.txt` (and any other `.txt` file) was being ignored during the Docker build process, even though the Dockerfile tried to copy all files with `COPY . /app/`.

## Solution

Added an exception to the `.dockerignore` file to explicitly include `requirements.txt`:

```dockerignore
*.txt
!requirements.txt
```

The `!` prefix in `.dockerignore` means "exception" - it tells Docker to include this file even though it matches a previous exclusion pattern.

## Files Modified

- `.dockerignore` - Added `!requirements.txt` exception on line 32

## How to Deploy on Railway

1. **Commit and push the fix** (if not already done):
   ```bash
   git add .dockerignore
   git commit -m "fix: include requirements.txt in Docker build"
   git push
   ```

2. **Redeploy on Railway**:
   - Go to your Railway dashboard
   - Find your GarudRecon project
   - Click on the service
   - Click the **"⋮"** (three dots) menu → **"Redeploy"**
   - Or just push to your connected branch - Railway will auto-deploy

3. **Verify the build succeeds**:
   - Watch the build logs in Railway
   - Look for successful Python dependency installation:
     ```
     Successfully installed Flask-3.0.0 flask-cors-4.0.0
     ```

4. **Test the deployment**:
   ```bash
   curl https://your-app.railway.app/api/health
   ```

## Why This Happened

The `.dockerignore` file was designed to exclude scan output files (`*.txt`, `*.json`, `*.csv`) to keep the Docker image small. However, this also inadvertently excluded the critical `requirements.txt` file.

## Best Practice

When using wildcards in `.dockerignore`, always check if any critical files match the pattern and add explicit exceptions using `!filename`.

Common files that should be excepted:
- `!requirements.txt` (Python dependencies)
- `!package.json` (Node.js dependencies)
- `!go.mod` (Go dependencies)
- `!Cargo.toml` (Rust dependencies)

## Related Documentation

- [RAILWAY_BUILD_FIX.md](RAILWAY_BUILD_FIX.md) - Fix for Go tool installation failures
- [RAILWAY_DEPLOYMENT_GUIDE.md](RAILWAY_DEPLOYMENT_GUIDE.md) - Complete Railway setup guide
- [RAILWAY_QUICK_FIX.md](RAILWAY_QUICK_FIX.md) - Quick troubleshooting for 0 results

## Timeline

This issue was discovered during Railway deployment and fixed by adding the `.dockerignore` exception. The build should now succeed and install Flask dependencies properly.
