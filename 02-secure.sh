#!/bin/bash

# Deshabilitar login por root
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# Activar firewall
ufw allow OpenSSH
ufw allow "Nginx Full"
ufw --force enable

echo "✅ Seguridad básica aplicada (firewall + login root deshabilitado)."
