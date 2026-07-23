# Caddy Docker Proxy + Cloudflare DNS + CrowdSec Bouncer

[![GHCR Package](https://img.shields.io/badge/container-GHCR-blue?logo=github&style=flat-square)](https://github.com/eagleeyetom/caddy-docker-proxy-crowdsec/pkgs/container/caddy-docker-proxy-crowdsec)

This repository hosts a multi-architecture (`linux/amd64`, `linux/arm64`) Docker image for **Caddy** containing:
* **[caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)**: Automatic Caddy configuration generation via Docker labels.
* **[caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)**: Support for Let's Encrypt / ZeroSSL DNS-01 challenges via Cloudflare API.
* **[caddy-crowdsec-bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer)**: Real-time traffic filtering and malicious IP banning integrated with CrowdSec.

> [!NOTE]
> **Cloudflare** and **CrowdSec** integrations are pre-installed in the image binary, but using them is **completely optional**. You can use this image as a drop-in replacement for standard `caddy-docker-proxy`.

---

## ⚙️ Optional Integrations

Both plugins are activated **only** when configured:

* **Cloudflare DNS (`caddy-dns/cloudflare`)**:
  * **Optional.** Used for DNS-01 challenge SSL certificate generation (e.g., for wildcard certificates or servers behind firewalls).
  * If omitted, Caddy falls back to standard ACME HTTP-01 / TLS-ALPN-01 challenges or custom certificates.
* **CrowdSec Bouncer (`caddy-crowdsec-bouncer`)**:
  * **Optional.** Only filters traffic on routes where the `caddy.crowdsec` label is explicitly added.
  * If omitted, Caddy operates as a normal reverse proxy without IP filtering.

---

## 🚀 Quick Start

### 1. Docker Compose Configuration for Caddy

Run Caddy using this image:

```yaml
services:
  caddy:
    image: ghcr.io/eagleeyetom/caddy-docker-proxy-crowdsec:latest
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    environment:
      CADDY_INGRESS_NETWORKS: "caddy"
      CF_DNS_API_TOKEN: "your-cloudflare-api-token" # Optional: Only if using Cloudflare DNS-01
      DOCKER_HOST: "tcp://docker-proxy:2375"
    volumes:
      - caddy_data:/data
      - caddy_config:/config
      - caddy_logs:/var/log/caddy
    networks:
      - caddy
```

### 2. Configure Service Labels

#### Optional: Global CrowdSec Bouncer Setup (e.g. on your `crowdsec` container)
```yaml
labels:
  caddy.crowdsec.api_url: "http://crowdsec:8080"
  caddy.crowdsec.api_key: "your_crowdsec_bouncer_api_key"
  caddy.order: "crowdsec first"
```

#### Application Container Labels
```yaml
labels:
  caddy: "app.yourdomain.com"
  caddy.reverse_proxy: "{{upstreams 80}}"
  caddy.tls.dns: "cloudflare {env.CF_DNS_API_TOKEN}" # Optional: Only if using Cloudflare DNS-01
  caddy.log.output: "file /var/log/caddy/access.log"
  caddy.log.format: "json"
  caddy.crowdsec: "" # Optional: Enables CrowdSec protection for this route
```

---

## 🛠️ GitHub Actions Workflow

This repository automatically compiles and updates the Docker image using GitHub Actions. The images are published to the **GitHub Container Registry (GHCR)**.

### Features:
* **Multi-Arch Builds**: Natively compiles for `amd64` and `arm64`.
* **Automated Tagging**: Automatically tags releases matching semantic versioning (`v*.*.*`), branches, and `latest`.
* **Docker Cache**: Uses GitHub Actions cache for super-fast subsequent builds.
