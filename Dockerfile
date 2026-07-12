FROM caddy:builder-alpine AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http

FROM lucaslorentz/caddy-docker-proxy:alpine

COPY --from=builder /usr/bin/caddy /bin/caddy
