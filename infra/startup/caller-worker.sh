#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

apt-get update -y
apt-get install -y curl ca-certificates git

rm -rf /opt/alchemx

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

node -v
npm -v

git clone https://github.com/aarctanz/alchemx-y.git /opt/alchemx
cd /opt/alchemx/app/workers/caller-worker

npm ci
npm run build

cat >/etc/systemd/system/caller-worker.service <<'EOF'
[Unit]
Description=iii caller worker (Node.js)
After=network-online.target
Wants=network-online.target

[Service]
Environment=III_URL=ws://10.10.1.10:49134
Environment=HOME=/root
WorkingDirectory=/opt/alchemx/app/workers/caller-worker
ExecStart=/usr/bin/node dist/worker.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable caller-worker.service
systemctl start caller-worker.service
systemctl status caller-worker.service --no-pager || true
