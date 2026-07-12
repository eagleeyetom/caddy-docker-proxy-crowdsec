ARG CADDY_VERSION=2.11.4
ARG CDP_VERSION=2.8.10
ARG BOUNCER_VERSION=0.13.1

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@v${CDP_VERSION} \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http@v${BOUNCER_VERSION}

FROM lucaslorentz/caddy-docker-proxy:${CDP_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /bin/caddy
