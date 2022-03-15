#!/bin/bash
set -ex

$COMMON_DIR/install_nvidiagpudriver.sh

# Install NV Peer Memory (GPU Direct RDMA)
NV_PEER_MEMORY_VERSION="1.3-0"
TARBALL="${NV_PEER_MEMORY_VERSION}.tar.gz"
NV_PEER_MEMORY_DOWNLOAD_URL=https://github.com/Mellanox/nv_peer_memory/archive/refs/tags/${TARBALL}
wget ${NV_PEER_MEMORY_DOWNLOAD_URL}
tar -xvf ${TARBALL}
pushd ./nv_peer_memory-${NV_PEER_MEMORY_VERSION}
yum install -y rpm-build
./build_module.sh 
rpmbuild --rebuild /tmp/nvidia_peer_memory-${NV_PEER_MEMORY_VERSION}.src.rpm
rpm -ivh ~/rpmbuild/RPMS/x86_64/nvidia_peer_memory-${NV_PEER_MEMORY_VERSION}.x86_64.rpm
echo "exclude=nvidia_peer_memory" | sudo tee -a /etc/yum.conf
sudo modprobe nv_peer_mem
lsmod | grep nv
popd

sudo bash -c "cat > /etc/modules-load.d/nv_peer_mem.conf" <<'EOF'
nv_peer_mem
EOF

sudo systemctl enable nv_peer_mem.service
$COMMON_DIR/write_component_version.sh "NV_PEER_MEMORY" ${NV_PEER_MEMORY_VERSION}

# Install GDRCopy
GDRCOPY_VERSION="2.3"
TARBALL="v${GDRCOPY_VERSION}.tar.gz"
GDRCOPY_DOWNLOAD_URL=https://github.com/NVIDIA/gdrcopy/archive/refs/tags/${TARBALL}
wget $GDRCOPY_DOWNLOAD_URL
tar -xvf $TARBALL

pushd gdrcopy-${GDRCOPY_VERSION}/packages/
CUDA=/usr/local/cuda ./build-rpm-packages.sh
rpm -Uvh gdrcopy-kmod-${GDRCOPY_VERSION}-1dkms.noarch.el8.rpm
echo "exclude=gdrcopy-kmod.noarch" | sudo tee -a /etc/yum.conf
rpm -Uvh gdrcopy-${GDRCOPY_VERSION}-1.x86_64.el8.rpm
echo "exclude=gdrcopy" | sudo tee -a /etc/yum.conf
rpm -Uvh gdrcopy-devel-${GDRCOPY_VERSION}-1.noarch.el8.rpm
echo "exclude=gdrcopy-devel.noarch" | sudo tee -a /etc/yum.conf
popd

$COMMON_DIR/write_component_version.sh "GDRCOPY" ${GDRCOPY_VERSION}

# Install Fabric Manager
NVIDIA_FABRIC_MANAGER_VERSION="510.47.03-1"
NVIDIA_FABRIC_MNGR_URL=http://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/nvidia-fabric-manager-${NVIDIA_FABRIC_MANAGER_VERSION}.x86_64.rpm
$COMMON_DIR/download_and_verify.sh ${NVIDIA_FABRIC_MNGR_URL} "33f0b2ad215af64712bfb34fb3f5a2eb9e0d2878e259e240a7fa74759288336d"
yum install -y ./nvidia-fabric-manager-${NVIDIA_FABRIC_MANAGER_VERSION}.x86_64.rpm
echo "exclude=nvidia-fabric-manager" | sudo tee -a /etc/yum.conf
systemctl enable nvidia-fabricmanager
systemctl start nvidia-fabricmanager
$COMMON_DIR/write_component_version.sh "NVIDIA_FABRIC_MANAGER" ${NVIDIA_FABRIC_MANAGER_VERSION}

# cleanup downloaded files
rm -rf *.run *tar.gz *.rpm
rm -rf -- */
