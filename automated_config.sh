#!/bin/bash

# --- CONFIGURACIÓN INICIAL ---
USERNAME=<YOUR_USERNAME>
APP_NAME=<YOUR_APP_NAME>
DB_USER=<YOUR_DB_USER>
DB_PASSWORD=<YOUR_DB_PASSWORD>

# --- 1. Crear nuevo usuario ---
adduser --disabled-password --gecos "" $USERNAME
usermod -aG sudo $USERNAME
mkdir -p /home/$USERNAME/.ssh
cp /root/.ssh/authorized_keys /home/$USERNAME/.ssh/
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# --- 2. Validar login SSH con nuevo usuario ---
echo "✅ Verifica que puedes hacer login como $USERNAME antes de continuar."
echo "ssh $USERNAME@<SERVER_IP>"
echo "Presiona ENTER para continuar después de verificar..."
read

# --- 3. Deshabilitar login por root ---
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# --- 4. Firewall básico ---
ufw allow OpenSSH
ufw allow "Nginx Full"
ufw --force enable

# --- 5. Actualizar sistema ---
apt update && apt upgrade -y
apt install -y git curl unzip wget build-essential libssl-dev zsh gnupg2 ca-certificates lsb-release

# --- 6. Instalar Oh My Zsh ---
su - $USERNAME -c "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" --unattended"

# --- 7. Instalar ASDF, Erlang, Elixir y Node.js ---
su - $USERNAME -c "\
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1 && \\
  echo '. \"$HOME/.asdf/asdf.sh\"' >> ~/.zshrc && \\
  echo '. \"$HOME/.asdf/completions/asdf.bash\"' >> ~/.zshrc && \\
  source ~/.zshrc && \\
  asdf plugin add erlang && \\
  asdf plugin add elixir && \\
  asdf plugin add nodejs && \\
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring && \\
  asdf install erlang 27.3.3 && \\
  asdf install elixir 1.18.3 && \\
  asdf install nodejs 20.12.2 && \\
  asdf global erlang 27.3.3 && \\
  asdf global elixir 1.18.3 && \\
  asdf global nodejs 20.12.2 && \\
  mkdir -p ~/app && cd ~/app && npm init -y && npm install gsap"

# --- 8. Instalar PostgreSQL ---
apt install -y postgresql postgresql-contrib
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"
sudo -u postgres psql -c "ALTER ROLE $DB_USER CREATEDB;"

# --- 9. Instalar NGINX ---
apt install -y nginx
systemctl enable nginx
systemctl start nginx

# --- 10. Crear carpeta de despliegue ---
mkdir -p /home/$USERNAME/apps/$APP_NAME
chown -R $USERNAME:$USERNAME /home/$USERNAME/apps

# --- Done ---
echo "\n✅ Servidor inicializado correctamente."
echo "➡️  Conectarse como: ssh $USERNAME@<SERVER_IP>"
echo "⚠️  Recuerda ejecutar Certbot y configurar tu NGINX más adelante."
