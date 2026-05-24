#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

apt-get update -y
apt-get install -y curl ca-certificates

curl -fsSL https://install.iii.dev/iii/main/install.sh | sh

IIIBIN="$(command -v iii || true)"
if [ -z "$IIIBIN" ]; then
  IIIBIN="/root/.local/bin/iii"
fi

test -x "$IIIBIN"
ln -sf "$IIIBIN" /usr/local/bin/iii

/usr/local/bin/iii --version

mkdir -p /opt/alchemx

cat >/etc/systemd/system/iii-engine.service <<'EOF'
[Unit]
Description=iii engine (gateway)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/alchemx
Environment=HOME=/root
Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin
ExecStart=/usr/local/bin/iii --use-default-config --no-update-check
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable iii-engine.service
systemctl start iii-engine.service
systemctl status iii-engine.service --no-pager || true
