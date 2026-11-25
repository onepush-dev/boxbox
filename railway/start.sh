#!/bin/sh
# Railway boot step for BoxBox: write config.yaml, fix volume ownership, then run the unmodified server as UID 10001.
set -e
if [ -z "${BOXBOX_ADMIN_PASSWORD}" ] || [ -z "${BOXBOX_JWT_SECRET}" ]; then
  echo "[railway] BOXBOX_ADMIN_PASSWORD and BOXBOX_JWT_SECRET must be set; refusing to start an open file manager" >&2
  exit 1
fi
USER_NAME="${BOXBOX_ADMIN_USER:-admin}"
HASH="$(bchash "${BOXBOX_ADMIN_PASSWORD}")"
mkdir -p /data/files /data/state /tmp/boxbox
PUBLIC=""
[ -n "${RAILWAY_PUBLIC_DOMAIN}" ] && PUBLIC="https://${RAILWAY_PUBLIC_DOMAIN}"
cat > /app/config.yaml <<YAML
port: 8080
host: "0.0.0.0"
data_dir: "/data/state"
public_url: "${PUBLIC}"
trusted_proxies: ["0.0.0.0/0", "::/0"]
rate_limit_rps: 2
max_upload_mb: 10240
chunk_size_mb: 10
users:
  ${USER_NAME}: '${HASH}'
mount_points:
  - name: "files"
    path: "/data/files"
    read_only: false
YAML
chown -R 10001:10001 /data /tmp/boxbox /app/config.yaml
chmod 0700 /tmp/boxbox
unset BOXBOX_ADMIN_PASSWORD
echo "[railway] wrote /app/config.yaml with admin user '${USER_NAME}' and a writable mount 'files' at /data/files"
export CONFIG_PATH=/app/config.yaml TMPDIR=/tmp/boxbox
exec su-exec 10001:10001 /app/server
