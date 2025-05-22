# 🧱 Ubuntu Server + Phoenix App Setup

Este repositorio contiene la documentación y los scripts necesarios para provisionar una máquina Ubuntu y desplegar proyectos en Elixir + Phoenix Framework de forma segura y reproducible.

---
Con este [Link de Referidos](https://m.do.co/c/a8f2bbcf381e) puedes levantar una máquina en DigitalOcean. Te dan USD 200 de crédito.
---

## 📁 Scripts Overview

This repository is organized into **three setup scripts**, to be run in order:

### ✅ `01-bootstrap.sh`
Executed as `root` after spinning up the server.
- Creates a new non-root user (`<YOUR_USERNAME>`)
- Adds it to the `sudo` group
- Copies SSH authorized keys from root
- **Prompts to set a password** for the new user (required to use `sudo`)
- Prompts you to validate SSH access by logging in as the new user

### ✅ `02-secure.sh`
Executed **after** validating login with the new user.
- Disables root login over SSH (edits `sshd_config` and restarts `ssh`)
- Enables the UFW firewall (allows OpenSSH and NGINX if installed)
- Ignores the NGINX rule gracefully if it doesn't exist yet

### ✅ `03-setup-app.sh`
Executed as the **new user** (`<YOUR_USERNAME>`).
- Installs:
  - Zsh + Oh-My-Zsh
  - ASDF with Erlang, Elixir, Node.js
  - PostgreSQL (configured with custom user/password)
  - NGINX
  - GSAP via npm (optional frontend lib)
- Creates your app folder at `~/apps/<YOUR_APP_NAME>`

---

## ⚠️ Security Notes

- Never disable root login before validating SSH access with your new user.
- Environment variables like `DB_PASSWORD` are placeholders—consider safer secret management tools for production.

---

## ✅ Final Checklist

- [x] Confirm you can login as `<YOUR_USERNAME>`
- [x] Set a password for the new user to enable `sudo`
- [x] Run `02-secure.sh` only after SSH validation
- [x] Run `03-setup-app.sh` as the new user
- [x] Configure SSL with Certbot (not included here)
- [x] Configure your Phoenix app service with `systemd`

---

## 📚 Extended Docs

This repo also includes the following detailed guides:

- [`ubuntu-server-setup.md`](./ubuntu-server-setup.md) — full manual setup of an Ubuntu server
- [`elixir-deploy-from-github-actions.md`](./elixir-deploy-from-github-actions.md) — deploy a Phoenix release from GitHub Actions to your server

---

## 🧠 Example Usage
```bash
# As root:
sudo bash 01-bootstrap.sh

# Login as the new user, then:
sudo bash 02-secure.sh

# Login again as the user:
bash 03-setup-app.sh
```

---

## 🤝 Contributions
Feel free to fork and adapt to your stack. PRs welcome!

---

## 📜 License
MIT
