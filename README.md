# 🧱 Ubuntu Server + Phoenix App Setup

Este repositorio contiene la documentación y los scripts necesarios para provisionar una máquina Ubuntu y desplegar proyectos en Elixir + Phoenix Framework de forma segura y reproducible.

---
Con este [Link de Referidos](https://m.do.co/c/a8f2bbcf381e) puedes levantar una máquina en DigitalOcean. Te dan USD 200 de crédito.
---

## 📘 Documentos incluidos

### 1. [`ubuntu_elixir_setup.md`](./ubuntu_elixir_setup.md)
Guía detallada para preparar una máquina Ubuntu desde cero para producción, incluyendo:

- Creación de usuario con permisos `sudo` y llaves SSH
- Instalación de Elixir `1.18.3` con OTP `27` usando `asdf`
- Instalación y configuración segura de PostgreSQL
- Instalación de Node.js y dependencias frontend (como GSAP)
- Configuración básica de firewall con UFW
- Setup de NGINX como reverse proxy
- Recomendaciones adicionales para hardening del servidor

> ✅ Ideal para levantar una nueva instancia de servidor lista para producción.

---

### 2. [`phoenix_deploy_workflow.yml`](./phoenix_deploy_workflow.yml)
Archivo de GitHub Actions para hacer deploy automatizado desde `main`:

- Construcción del release con `mix release`
- Digest de assets con `phx.digest`
- Transferencia vía SSH y despliegue controlado con `systemd`
- Compatibilidad con NGINX como proxy inverso

> 🔁 Reutilizable para múltiples proyectos Phoenix.

---

## 🚀 Cómo usar este repositorio

1. Sigue las instrucciones de `ubuntu_elixir_setup.md` en tu nueva instancia Ubuntu
2. Configura tu proyecto Phoenix como `release` y usa el workflow `phoenix_deploy_workflow.yml`
3. Ajusta los placeholders (`<USERNAME>`, `<APP_NAME>`, `<DB_USER>`, etc.) a tus necesidades
4. Opcional: configura Certbot para HTTPS (no incluido aquí)

---

## 📦 Requisitos

- Ubuntu 22.04 o superior
- Acceso SSH al servidor
- Un proyecto Phoenix configurado para releases

---

## 🛡️ Seguridad recomendada

- Deshabilita acceso SSH a `root`
- Usa claves SSH fuertes y desactiva contraseñas
- Habilita UFW con puertos mínimos necesarios (`22`, `80`, `443`)

---

## ✨ Créditos

Este setup fue documentado para facilitar el despliegue continuo de proyectos Phoenix en servidores autogestionados, manteniendo buenas prácticas de seguridad y reproducibilidad.

---
