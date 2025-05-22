#!/bin/bash

USERNAME=<YOUR_USERNAME>

# Crear nuevo usuario sin contraseña y agregar a sudoers
adduser --disabled-password --gecos "" $USERNAME
usermod -aG sudo $USERNAME

# Copiar llaves SSH desde root
mkdir -p /home/$USERNAME/.ssh
cp /root/.ssh/authorized_keys /home/$USERNAME/.ssh/
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

echo "✅ Usuario $USERNAME creado. Verifica que puedes hacer login vía SSH antes de continuar."
echo "ℹ️ Ejecuta: ssh $USERNAME@<SERVER_IP>"
