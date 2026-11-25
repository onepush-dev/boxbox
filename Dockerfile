# BoxBox on Railway: the ghcr.io/jr4dh3y/boxbox:v0.3.2 image (MIT upstream), application unmodified.
# Railway layer: a boot step writes /app/config.yaml (one writable mount on the /data volume, an admin user whose
# bcrypt hash is derived from BOXBOX_ADMIN_PASSWORD, JWT secret from BOXBOX_JWT_SECRET, public URL from the Railway domain)
# so the file manager is never open and needs no inputs.
FROM golang:1.23-alpine AS hash
WORKDIR /src
COPY hash/ ./
RUN go mod init bchash && go get golang.org/x/crypto/bcrypt@v0.31.0 && CGO_ENABLED=0 go build -o /bchash .

FROM ghcr.io/jr4dh3y/boxbox:v0.3.2
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/boxbox"
USER root
RUN apk add --no-cache su-exec
COPY --from=hash /bchash /usr/local/bin/bchash
COPY --chmod=755 railway/start.sh /usr/local/bin/railway-start
ENV BOXBOX_ADMIN_USER=admin
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-start"]
