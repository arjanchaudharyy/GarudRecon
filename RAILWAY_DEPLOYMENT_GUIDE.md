# Railway Deployment Guide for GarudRecon

## Quick Deploy to Railway

### Option 1: Deploy with Pre-installed Tools (Recommended)

This repository includes a Dockerfile that pre-installs all required reconnaissance tools during the build process.

**Steps:**

1. **Fork or Clone this repository**
   ```bash
   git clone https://github.com/arjanchaudharyy/GarudRecon.git
   cd GarudRecon
   ```

2. **Push to your GitHub repository** (if not already there)

3. **Deploy on Railway:**
   - Go to [Railway.app](https://railway.app)
   - Click "New Project" → "Deploy from GitHub repo"
   - Select your GarudRecon repository
   - Railway will automatically detect the `Dockerfile` and `railway.toml`
   - Wait for build to complete (5-10 minutes)

4. **Access your deployment:**
   - Railway will provide a public URL
   - Visit `https://your-app.railway.app` to access the web interface

### Option 2: Manual Configuration

If you want to customize the deployment:

1. **Create a new Railway project**
   ```bash
   railway init
   ```

2. **Set environment variables** (optional):
   ```bash
   railway variables set PORT=5000
   ```

3. **Deploy:**
   ```bash
   railway up
   ```

## What Gets Installed in the Docker Image

The Dockerfile automatically installs:

### System Tools
- `dig` - DNS lookup tool
- `nmap` - Network scanner
- `curl` / `wget` - HTTP clients
- `git` - Version control
- `jq` - JSON processor
- `netcat` / `whois` - Network utilities

### Go Language & Tools
- **Go 1.21.5** - Programming language
- **httpx** - HTTP toolkit
- **subfinder** - Subdomain discovery
- **dnsx** - DNS toolkit
- **naabu** - Port scanner
- **nuclei** - Vulnerability scanner
- **katana** - Web crawler
- **waybackurls** - Wayback Machine URL fetcher
- **gau** - Get All URLs
- **assetfinder** - Domain asset finder
- **dalfox** - XSS scanner
- **gf** - Grep wrapper for patterns
- **anew** - Add new lines to files

### Python Tools
- **Flask** - Web framework
- **sqlmap** - SQL injection scanner

## Build Process

The Docker build process:

1. Installs Ubuntu 22.04 base image
2. Installs system packages (5-30 seconds)
3. Downloads and installs Go (30-60 seconds)
4. Compiles and installs Go-based recon tools (3-5 minutes)
5. Installs Python dependencies (30-60 seconds)
6. Verifies tool installation
7. Total build time: **5-10 minutes**

## Verifying Tool Installation

After deployment, check the Railway logs to verify tools were installed:

```
=== Verifying tool installation ===
System tools:
/usr/bin/dig
/usr/bin/nmap
/usr/bin/curl
...
Go tools:
/root/go/bin/httpx
/root/go/bin/subfinder
/root/go/bin/nuclei
...
===================================
```

You can also check via the API:
```bash
curl https://your-app.railway.app/api/tools
```

## Troubleshooting

### Issue: Tools not found / Scans show 0 results

**Cause:** Tools weren't installed during Docker build.

**Solution:**
1. Check Railway build logs for errors
2. Look for failed `go install` commands
3. Check if the build timed out
4. Try rebuilding: Railway Dashboard → Three dots → "Redeploy"

### Issue: Build fails or times out

**Cause:** Go tool compilation can take time and may timeout on free tier.

**Solutions:**
- Railway free tier has generous build times, but if it times out:
  - Try deploying during off-peak hours
  - Remove some less essential tools from Dockerfile
  - Use a minimal tools configuration

### Issue: Container crashes on startup

**Cause:** Health check may be failing.

**Solution:**
1. Check Railway logs for Python errors
2. Verify `PORT` environment variable is set correctly
3. Check if `/api/health` endpoint is accessible

### Issue: Missing specific tools

**Cause:** Individual tool installation failed during build.

**Solution:**
1. Check which tool failed in build logs
2. The Dockerfile continues even if individual tools fail
3. You can manually add the tool installation or remove it from Dockerfile

## Configuration Files

### `railway.toml`
```toml
[build]
builder = "DOCKERFILE"
dockerfilePath = "Dockerfile"

[deploy]
startCommand = "python3 web_backend.py"
healthcheckPath = "/api/health"
healthcheckTimeout = 300
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 10
```

### `Dockerfile`
The Dockerfile handles all tool installation. See the file for full details.

## Performance Considerations

### Build Time
- First build: 5-10 minutes (compiling Go tools)
- Subsequent builds: 2-5 minutes (using cached layers)

### Runtime Performance
- **Light Scan**: 5-10 minutes
- **Cool Scan**: 20-30 minutes
- **Ultra Scan**: 1-2 hours

### Resource Usage
- **Memory**: 512MB-1GB (depending on scan type)
- **CPU**: 1-2 vCPUs recommended
- **Storage**: 2-5GB for scans and results

## Security Notes

1. **API Access**: The API is publicly accessible. Consider adding authentication.
2. **Rate Limiting**: No built-in rate limiting. Add reverse proxy if needed.
3. **Scan Targets**: Only scan domains you own or have permission to test.
4. **Results Storage**: Scan results are stored in `/app/scans` directory.

## Cost Optimization

Railway free tier includes:
- $5 of usage per month
- No credit card required
- Sufficient for testing and development

For production:
- Monitor usage in Railway dashboard
- Consider adding rate limiting
- Implement scan queuing for high traffic

## Alternative: Local Docker

If you want to test locally before deploying:

```bash
# Build the image
docker build -t garudrecon .

# Run locally
docker run -p 5000:5000 garudrecon

# Access at http://localhost:5000
```

## Support

For issues specific to:
- **GarudRecon**: Open issue at https://github.com/arjanchaudharyy/GarudRecon
- **Railway Platform**: Check Railway documentation or Discord
- **Tool Installation**: See `TOOL_INSTALLATION_GUIDE.md`

## Next Steps

After successful deployment:

1. Access the web interface at your Railway URL
2. Run a test scan on a domain you own
3. Check the logs to verify tools are working
4. Review the results in JSON format
5. Set up any necessary monitoring or alerts

## Additional Resources

- [Railway Documentation](https://docs.railway.app)
- [GarudRecon Documentation](./README.md)
- [Tool Installation Guide](./TOOL_INSTALLATION_GUIDE.md)
- [Web Interface Guide](./WEB_INTERFACE.md)
