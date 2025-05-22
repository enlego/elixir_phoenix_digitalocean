#!/bin/bash

USERNAME=<YOUR_USERNAME>

# 1. Crear nuevo usuario
adduser --disabled-password --gecos "" $USERNAME
usermod -aG sudo $USERNAME
mkdir -p /home/$USERNAME/.ssh
cp /root/.ssh/authorized_keys /home/$USERNAME/.ssh/
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

echo "✅ Usuario $USERNAME creado."
echo "🔐 Verifica que puedes loguearte en otra terminal con: ssh $USERNAME@<SERVER_IP>"
