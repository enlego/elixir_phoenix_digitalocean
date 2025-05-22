#!/bin/bash

set -e

# 🔧 Configurable variables
DOMAIN_NAME="<YOUR_DOMAIN>"           # e.g. example.com
APP_PORT=4000                         # Port your Phoenix app listens on
NGINX_SITE="/etc/nginx/sites-available/$DOMAIN_NAME"
NGINX_LINK="/etc/nginx/sites-enabled/$DOMAIN_NAME"

# 🛠️ Install NGINX
sudo apt update
sudo apt install -y nginx

# 🔐 Allow HTTP through the firewall
sudo ufw allow 'Nginx HTTP'

# 📄 Create NGINX config for the domain
sudo tee "$NGINX_SITE" > /dev/null <<'EOF'
# Redirección http:// → https://
server {
        listen 80;
        server_name $DOMAIN_NAME www.$DOMAIN_NAME;
        return 301 https://www.$DOMAIN_NAME$request_uri;
}

# Redirección sin www → a www (https)
server {
        listen 443 ssl;
        server_name $DOMAIN_NAME;

        return 301 https://www.$DOMAIN_NAME$request_uri;
}

# Sitio principal: www.$DOMAIN_NAME
server {
        listen 443 ssl;
        server_name www.$DOMAIN_NAME;

        # Para validación de Certbot
        location /.well-known/acme-challenge/ {
                root /var/www/html;
        }



        # Proxy a la app Phoenix
        location / {
                proxy_pass http://localhost:4000;
                proxy_http_version 1.1;

                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;

                # WebSockets (LiveView)
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
        }
}
EOF

# 🔗 Enable the site
sudo ln -sf "$NGINX_SITE" "$NGINX_LINK"

# 🔁 Reload NGINX
sudo nginx -t && sudo systemctl reload nginx

echo "✅ NGINX configured for $DOMAIN_NAME pointing to localhost:$APP_PORT"
