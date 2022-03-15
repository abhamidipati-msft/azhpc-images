#!/bin/bash
set -ex

# Install DCGM

DCGM_VERSION=2.3.6
DCGM_URL=https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/datacenter-gpu-manager-${DCGM_VERSION}-1-x86_64.rpm
$COMMON_DIR/download_and_verify.sh $DCGM_URL "54ed196fdb5f3e23afe422f054e86f49d3099a59f20bcff496ed1979929f4381"
sudo rpm -i datacenter-gpu-manager-${DCGM_VERSION}-1-x86_64.rpm
sudo rm -f datacenter-gpu-manager-${DCGM_VERSION}-1-x86_64.rpm
$COMMON_DIR/write_component_version.sh "DCGM" ${DCGM_VERSION}

# Create service for dcgm to launch on bootup
sudo bash -c "cat > /etc/systemd/system/dcgm.service" <<'EOF'
[Unit]
Description=DCGM service

[Service]
User=root
PrivateTmp=false
ExecStart=/usr/bin/nv-hostengine -n
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable dcgm
sudo systemctl start dcgm
