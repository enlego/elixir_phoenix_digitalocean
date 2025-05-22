#!/bin/bash

set -e

# 🔧 Configurable variables
DOMAIN_NAME="<YOUR_DOMAIN>"           # e.g. www.example.com
APP_PORT=4000                         # Port your Phoenix app listens on
NGINX_SITE="/etc/nginx/sites-available/$DOMAIN_NAME"
NGINX_LINK="/etc/nginx/sites-enabled/$DOMAIN_NAME"

# 🛠️ Install NGINX
sudo apt update
sudo apt install -y nginx

# 🔐 Allow HTTP through the firewall
sudo ufw allow 'Nginx HTTP'

# 📄 Create NGINX config for the domain
sudo tee "$NGINX_SITE" > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN_NAME;

    location / {
        proxy_pass http://localhost:$APP_PORT;
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # WebSockets
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /assets/ {
        proxy_pass http://localhost:$APP_PORT;
        proxy_http_version 1.1;

        expires max;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# 🔗 Enable the site
sudo ln -sf "$NGINX_SITE" "$NGINX_LINK"

# 🔁 Reload NGINX
sudo nginx -t && sudo systemctl reload nginx

echo "✅ NGINX configured for $DOMAIN_NAME pointing to localhost:$APP_PORT"
