ARG CADDY_VERSION=2.11.4
ARG CDP_VERSION=2.13.1
ARG BOUNCER_VERSION=0.14.0

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

# Inherit ARGs inside the build stage
ARG CDP_VERSION
ARG BOUNCER_VERSION

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@v${CDP_VERSION} \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http@v${BOUNCER_VERSION}

FROM lucaslorentz/caddy-docker-proxy:${CDP_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /bin/caddy
