
# Ubuntu Server Setup for Elixir + Phoenix Projects

This guide documents the steps to provision and harden an Ubuntu server for running an Elixir Phoenix app with PostgreSQL, Node.js, and NGINX.

---

## 🧰 1. Initial Server Setup

### 1.1 Create new user
```bash
adduser <USERNAME>
usermod -aG sudo <USERNAME>
```

### 1.2 Copy SSH keys from root
```bash
rsync --archive --chown=<USERNAME>:<USERNAME> ~/.ssh /home/<USERNAME>
```

### 1.3 Disable root login
Edit `/etc/ssh/sshd_config`:
```bash
PermitRootLogin no
```
Then:
```bash
systemctl restart sshd
```

### 1.4 Enable UFW and open ports
```bash
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw enable
```

---

## 📦 2. Install System Dependencies

### 2.1 Update packages
```bash
apt update && apt upgrade -y
```

### 2.2 Install tools
```bash
apt install -y git curl unzip wget build-essential libssl-dev zsh
```

### 2.3 Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

## 🔧 3. Install Elixir & Erlang (OTP 27)

### 3.1 Install ASDF
```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc
source ~/.zshrc
```

### 3.2 Install Erlang & Elixir
```bash
asdf plugin add erlang
asdf plugin add elixir
asdf install erlang 27.3.3
asdf install elixir 1.18.3
asdf global erlang 27.3.3
asdf global elixir 1.18.3
```

---

## 🐘 4. Install and Secure PostgreSQL

### 4.1 Install PostgreSQL
```bash
apt install -y postgresql postgresql-contrib
```

### 4.2 Set up PostgreSQL user
```bash
sudo -u postgres psql
```
Inside psql:
```sql
CREATE USER <DB_USER> WITH PASSWORD '<DB_PASSWORD>';
ALTER ROLE <DB_USER> CREATEDB;
\q
```

### 4.3 Optional: Restrict local access to PostgreSQL
Edit `/etc/postgresql/14/main/pg_hba.conf` to:
```
local   all             postgres                                peer
local   all             <DB_USER>                               md5
```
Then:
```bash
systemctl restart postgresql
```

---

## 🧪 5. Install Node.js (for asset building)

### 5.1 Install via NodeSource
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

### 5.2 Install project deps (like GSAP)
```bash
npm install gsap
```

---

## 🧱 6. NGINX Setup

```bash
apt install -y nginx
systemctl enable nginx
systemctl start nginx
```
Configure a reverse proxy manually or with Certbot later.

---

## 🛠️ 7. Additional Notes

- You can generate a Phoenix app release and place it in `/home/<USERNAME>/apps/<APP_NAME>`
- Consider setting `ZSH_THEME="agnoster"` or similar in your `.zshrc`
- Make sure your Phoenix app uses `ip: {0, 0, 0, 0}` and port `4000` to serve requests

---

## ✅ Final Checklist

- [ ] Can SSH as `<USERNAME>` and root login is disabled
- [ ] UFW is active and ports 22, 80, and 443 are open
- [ ] PostgreSQL is running and has a user with privileges
- [ ] Elixir and Erlang are correctly installed via ASDF
- [ ] Node.js + GSAP are installed and functional
- [ ] You can serve a test Phoenix app via NGINX
