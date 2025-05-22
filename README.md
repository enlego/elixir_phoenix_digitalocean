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
- Prompts you to validate SSH access

### ✅ `02-secure.sh`
Executed **after** validating login with the new user.
- Disables root login over SSH
- Enables the UFW firewall (OpenSSH + NGINX)

### ✅ `03-setup-app.sh`
Executed as the **new user** (`<YOUR_USERNAME>`).
- Installs:
  - Zsh + Oh-My-Zsh
  - ASDF with Erlang, Elixir, Node.js
  - PostgreSQL (configured with custom user/password)
  - NGINX
  - GSAP via npm (optional frontend lib)
- Creates your app folder at `~/apps/<YOUR_APP_NAME>`

Each script corresponds to steps outlined in the accompanying markdown documentation:

- [`ubuntu-server-setup.md`](./ubuntu-server-setup.md): Manual instructions for setting up a new server
- [`elixir-deploy-from-github-actions.md`](./elixir-deploy-from-github-actions.md): Steps to configure GitHub Actions for deploying Phoenix apps to the server

---

## ⚠️ Security Notes

- Never disable root login before validating SSH access with your new user.
- Environment variables like `DB_PASSWORD` are placeholders—consider safer secret management tools for production.
- After running these scripts, configure `systemd` and SSL (e.g. with Certbot) manually.

---

## ✅ Final Checklist

- [ ] Confirm you can login as `<YOUR_USERNAME>`
- [ ] Run `02-secure.sh` only after SSH validation
- [ ] Run `03-setup-app.sh` as the new user
- [ ] Configure SSL with Certbot (not included here)
- [ ] Configure your Phoenix app service with `systemd`
- [ ] Make sure image/video/static assets are not excluded from Git

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


---

## ✨ Créditos

Este setup fue documentado para facilitar el despliegue continuo de proyectos Phoenix en servidores autogestionados, manteniendo buenas prácticas de seguridad y reproducibilidad.

---
