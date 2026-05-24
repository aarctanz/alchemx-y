#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

apt-get update -y
apt-get install -y git ca-certificates python3 python3-pip python3-venv

rm -rf /opt/alchemx

git clone https://github.com/aarctanz/alchemx-y.git /opt/alchemx
cd /opt/alchemx/app/workers/inference-worker

python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements.txt

cat >/etc/systemd/system/inference-worker.service <<'EOF'
[Unit]
Description=iii inference worker (Python)
After=network-online.target
Wants=network-online.target

[Service]
Environment=III_URL=ws://10.10.1.10:49134
Environment=HOME=/root
WorkingDirectory=/opt/alchemx/app/workers/inference-worker
ExecStart=/opt/alchemx/app/workers/inference-worker/.venv/bin/python3 inference_worker.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable inference-worker.service
systemctl start inference-worker.service
systemctl status inference-worker.service --no-pager ||true
