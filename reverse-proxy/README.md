# Nginx Reverse Proxy Setup with SSL/TLS Certificate

This guide will help you install Nginx, configure it as a reverse proxy for n8n, and secure it with a free SSL certificate using Certbot.

## Prerequisites

- A Linux server (Ubuntu/Debian recommended)
- A registered domain name pointing to your server's IP address
- SSH access to your server
- `sudo` privileges

## Step 1: Install Nginx

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install nginx
```

### Start and Enable Nginx

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

Verify installation:
```bash
sudo systemctl status nginx
```

## Step 2: Configure Nginx as Reverse Proxy

### 1. Edit the Nginx Configuration

Replace `YOUR_DOMAIN_HERE` with your actual domain and `HOST:PORT` with your n8n service address (e.g., `127.0.0.1:5678`).

```bash
sudo nano /etc/nginx/sites-available/default
```

### 2. Replace the Contents with Your Config

Copy the entire content from [`nginxconfig`](nginxconfig) and paste it into the editor. Update:

- `YOUR_DOMAIN_HERE` → Your actual domain (e.g., `n8n.example.com`)
- `HOST:PORT` → Your n8n service address (e.g., `127.0.0.1:5678`)

### 3. Test Nginx Configuration

```bash
sudo nginx -t
```

Expected output: `syntax is ok` and `test is successful`

### 4. Reload Nginx

```bash
sudo systemctl reload nginx
```

## Step 3: Install and Configure Certbot

### 1. Install Certbot

```bash
sudo apt install certbot python3-certbot-nginx
```

### 2. Obtain SSL Certificate

```bash
sudo certbot --nginx -d YOUR_DOMAIN_HERE
```

Replace `YOUR_DOMAIN_HERE` with your actual domain.

**During the process, Certbot will:**
- Ask for your email (for certificate renewal reminders)
- Ask you to agree to the terms
- Ask if you want to redirect HTTP to HTTPS (choose **Yes**)

### 3. Verify Certificate Installation

Certbot automatically updates your Nginx configuration. Check the updated config:

```bash
sudo cat /etc/nginx/sites-available/default
```

You should see:
- `listen 443 ssl;` (HTTPS)
- `ssl_certificate` and `ssl_certificate_key` paths
- HTTP redirect to HTTPS

### 4. Test Nginx Again

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Step 4: Enable Auto-Renewal

Certbot includes a systemd timer for automatic renewal. Verify it's enabled:

```bash
sudo systemctl enable certbot.timer
sudo systemctl status certbot.timer
```

Test the renewal process (dry run):

```bash
sudo certbot renew --dry-run
```

## Step 5: Firewall Configuration

### If Using UFW (Ubuntu Firewall)

```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow 22/tcp    # SSH
sudo ufw enable
```

## Step 6: Verify Setup

1. **Test HTTP to HTTPS redirect:**
   ```bash
   curl -I http://YOUR_DOMAIN_HERE
   ```
   Should return a 301 redirect to HTTPS.

2. **Test HTTPS connection:**
   ```bash
   curl -I https://YOUR_DOMAIN_HERE
   ```
   Should return a 200 status.

3. **Open in browser:**
   Navigate to `https://YOUR_DOMAIN_HERE` in your browser. You should see your n8n instance with a valid SSL certificate.

## Troubleshooting

### Certificate Not Found
```bash
sudo certbot certificates
```
Lists all certificates. Re-run `sudo certbot --nginx -d YOUR_DOMAIN_HERE` if needed.

### Nginx Won't Reload
```bash
sudo nginx -t
```
Check for configuration errors.

### Certificate Renewal Issues
```bash
sudo certbot renew --force-renewal
```

### View Nginx Logs
```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

## Update n8n Environment Variables

Update your [.env](.env) file with:

```
N8N_PROTOCOL=https
N8N_EDITOR_BASE_URL=https://YOUR_DOMAIN_HERE
WEBHOOK_URL=https://YOUR_DOMAIN_HERE
```

Restart n8n for changes to take effect:
```bash
docker compose -f docker-compose.vol.yml restart
```

## Security Best Practices

- Regularly update Nginx: `sudo apt update && sudo apt upgrade`
- Monitor certificate expiration: `sudo certbot certificates`
- Use strong firewall rules (only allow necessary ports)
- Keep n8n updated to the latest version
- Consider adding basic auth if needed (consult Nginx documentation)

## Additional Resources

- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [Certbot Documentation](https://certbot.eff.org/docs/)
- [n8n Hosting Guide](https://docs.n8n.io/hosting/)