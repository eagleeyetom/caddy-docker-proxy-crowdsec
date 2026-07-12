# Caddy Docker Proxy + Cloudflare DNS + CrowdSec Bouncer

This repository hosts a multi-architecture (`linux/amd64`, `linux/arm64`) Docker image for **Caddy** containing:
* **[caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)**: Automatic Caddy configuration generation via Docker labels.
* **[caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)**: Support for Let's Encrypt / ZeroSSL DNS-01 challenges via Cloudflare API.
* **[caddy-crowdsec-bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer)**: Real-time traffic filtering and malicious IP banning integrated with CrowdSec.

---

## 🚀 Quick Start

### 1. Build and Run Configuration

Add global Caddy and CrowdSec settings to your services using Docker labels.

#### Global Config Container Labels (e.g. on your `crowdsec` container)
```yaml
labels:
  caddy.crowdsec.api_url: "http://crowdsec:8080"
  caddy.crowdsec.api_key: "your_crowdsec_bouncer_api_key"
  caddy.order: "crowdsec first"
```

#### Protecting a Container (e.g. your app container)
To enable the CrowdSec filter on a specific domain route, add the `caddy.crowdsec` label:
```yaml
labels:
  caddy: "app.yourdomain.com"
  caddy.reverse_proxy: "{{upstreams 80}}"
  caddy.tls.dns: "cloudflare {env.CF_DNS_API_TOKEN}"
  caddy.log.output: "file /var/log/caddy/access.log"
  caddy.log.format: "json"
  caddy.crowdsec: "" # Enables protection
```

---

## 🛠️ GitHub Actions Workflow

This repository automatically compiles and updates the Docker image using GitHub Actions. The images are published to the **GitHub Container Registry (GHCR)**.

### Features:
* **Multi-Arch Builds**: Natively compiles for `amd64` and `arm64`.
* **Automated Tagging**: Automatically tags releases matching semantic versioning (`v*.*.*`), branches, and `latest`.
* **Docker Cache**: Uses GitHub Actions cache for super-fast subsequent builds.
