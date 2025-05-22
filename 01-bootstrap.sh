#!/bin/bash
set -e

# Prompt for username
read -p "Enter new username: " NEW_USER
adduser "$NEW_USER"
usermod -aG sudo "$NEW_USER"

# Copy SSH keys
mkdir -p /home/"$NEW_USER"/.ssh
cp /root/.ssh/authorized_keys /home/"$NEW_USER"/.ssh/
chown -R "$NEW_USER":"$NEW_USER" /home/"$NEW_USER"/.ssh
chmod 700 /home/"$NEW_USER"/.ssh
chmod 600 /home/"$NEW_USER"/.ssh/authorized_keys

# Prompt to set password
echo "Now set a password for $NEW_USER:"
passwd "$NEW_USER"

echo "✅ User $NEW_USER created. Validate SSH login before continuing."
