
# Phoenix Deploy Guide (Generic)

This guide documents the full process to configure and deploy a Phoenix application to a fresh server using GitHub Actions and systemd.

---

## 🧱 1. Server Setup

### Requirements
- Ubuntu server (22.04+ recommended). I use DigitalOcean. If you use [my referral link](https://m.do.co/c/a8f2bbcf381e) you get USD 200 in credit.
- SSH access
- GitHub repository with a Phoenix project

### Create deployment directory:
```bash
ssh <USER>@<SERVER_IP>
mkdir -p /home/<USER>/apps/<APP_NAME>
```

## 🔐 2. SSH Configuration for GitHub Actions

### On your **local machine**:
Generate a deploy key (or reuse one):
```bash
ssh-keygen -t rsa -b 4096 -C "github-actions" -f github-action-key
```

### On the **server**:
Add the public key to `authorized_keys`:
```bash
mkdir -p ~/.ssh
cat github-action-key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### On **GitHub**:
- Go to your repository → Settings → Secrets → Actions
- Add the private key as a secret:
  - Name: `DO_SSH_PRIVATE_KEY`
  - Value: contents of `github-action-key`

---

## ⚙️ 3. Systemd Service

Create `/etc/systemd/system/<APP_NAME>.service`:
```ini
[Unit]
Description=Phoenix App
After=network.target

[Service]
User=<USER>
WorkingDirectory=/home/<USER>/apps/<APP_NAME>
Environment=SECRET_KEY_BASE=<GENERATED_SECRET>
Environment=RELEASE_DISTRIBUTION=none
Environment=PHX_SERVER=true
Environment=PHX_HOST=<DOMAIN>
Environment=PORT=4000
ExecStart=/home/<USER>/apps/<APP_NAME>/bin/<APP_NAME> start
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Then:
```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable <APP_NAME>
```

---

## 🚀 4. GitHub Actions Deploy

Add `.github/workflows/deploy.yml`:
```yaml
name: 🚀 Deploy Phoenix to Server

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v3

      - name: 🧰 Install Elixir & Erlang
        uses: erlef/setup-beam@v1
        with:
          elixir-version: '1.18.3'
          otp-version: '27.3.3'

      - name: 🔐 Setup SSH
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.DO_SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan -H <SERVER_IP> >> ~/.ssh/known_hosts

      - name: 📦 Install Deps & Build Assets
        run: |
          mix deps.get
          MIX_ENV=prod mix assets.deploy
          MIX_ENV=prod mix phx.digest

      - name: 🏗️ Build Release
        run: |
          MIX_ENV=prod mix release --overwrite
          tar -czf release.tar.gz -C _build/prod/rel <APP_NAME>

      - name: 🚚 Upload Release
        run: |
          scp release.tar.gz <USER>@<SERVER_IP>:/tmp/release.tar.gz

      - name: 🚀 Deploy on Server
        run: |
          ssh <USER>@<SERVER_IP> << 'EOF'
            set -e
            sudo systemctl stop <APP_NAME> || true
            rm -rf /home/<USER>/apps/<APP_NAME>
            mkdir -p /home/<USER>/apps
            tar -xzf /tmp/release.tar.gz -C /home/<USER>/apps
            rm /tmp/release.tar.gz
            sudo systemctl start <APP_NAME>
          EOF
```

---

## 🧪 5. Validate Deployment

```bash
curl -I http://<DOMAIN>:4000
```
Or visit the domain if proxied via NGINX.

Use `journalctl -u <APP_NAME> -f` to inspect logs.

---

## 📦 Notes

- Ensure assets like `priv/static/images`, `fonts`, or videos are committed or copied into place manually if not generated.
- The `static_paths/0` function in `lib/<app>_web.ex` must include the folders and files to serve statically.
- For SSL and domain routing, run Certbot separately and configure NGINX.

---

## ✅ Ready to Go

You can now push to `main` to auto-deploy. Trigger manually via the GitHub UI if needed.
