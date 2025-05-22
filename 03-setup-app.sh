#!/bin/bash

APP_NAME=<YOUR_APP_NAME>
DB_USER=<YOUR_DB_USER>
DB_PASSWORD=<YOUR_DB_PASSWORD>

# Actualizar sistema
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl unzip wget build-essential libssl-dev zsh gnupg2 ca-certificates lsb-release postgresql postgresql-contrib nginx

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

# ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc
source ~/.asdf/asdf.sh

# Plugins y runtimes
asdf plugin add erlang
asdf plugin add elixir
asdf plugin add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

asdf install erlang 27.3.3
asdf install elixir 1.18.3
asdf install nodejs 20.12.2

asdf global erlang 27.3.3
asdf global elixir 1.18.3
asdf global nodejs 20.12.2

# Proyecto base y GSAP
mkdir -p ~/app && cd ~/app
npm init -y
npm install gsap

# Configurar PostgreSQL
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"
sudo -u postgres psql -c "ALTER ROLE $DB_USER CREATEDB;"

# Iniciar servicios
sudo systemctl enable postgresql
sudo systemctl enable nginx
sudo systemctl start postgresql
sudo systemctl start nginx

# Crear carpeta para el app
mkdir -p ~/apps/$APP_NAME

echo "✅ Setup completado. Revisa ~/.zshrc y reinicia terminal para usar ASDF."
