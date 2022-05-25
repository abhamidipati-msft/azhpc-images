#!/bin/bash
set -ex

VERSION="5.6-1.0.3.3"
TARBALL="MLNX_OFED_LINUX-$VERSION-rhel8.5-x86_64.tgz"
MLNX_OFED_DOWNLOAD_URL=https://azhpcstor.blob.core.windows.net/azhpc-images-store/$TARBALL
MOFED_FOLDER=$(basename ${MLNX_OFED_DOWNLOAD_URL} .tgz)

$COMMON_DIR/download_and_verify.sh $MLNX_OFED_DOWNLOAD_URL "aeae9814624f58592b968de4db9e60b9724a9887d7276bf61ed9b5b0c18d4187"
tar zxvf ${TARBALL}

KERNEL=( $(rpm -q kernel | sed 's/kernel\-//g') )
KERNEL=${KERNEL[-1]}
# Uncomment the lines below if you are running this on a VM
#RELEASE=( $(cat /etc/almalinux-release | awk '{print $3}') )
#yum -y install https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-devel-${KERNEL}.rpm
#yum install -y kernel-devel-${KERNEL}
yum install -y https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-headers-4.18.0-348.12.2.el8_5.x86_64.rpm
#yum install -y https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-rpm-macros-4.18.0-348.12.2.el8_5.x86_64.rpm
yum install -y --skip-broken https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-modules-extra-4.18.0-348.12.2.el8_5.x86_64.rpm
yum install -y https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-devel-4.18.0-348.20.1.el8_5.x86_64.rpm

./${MOFED_FOLDER}/mlnxofedinstall --kernel $KERNEL --kernel-sources /usr/src/kernels/${KERNEL} --add-kernel-support --skip-repo --skip-unsupported-devices-check --without-fw-update --distro rhel8.5

# Issue: Module mlx5_ib belong to a kernel which is not a part of MLNX
# Resolution: set FORCE=1/ force-restart /etc/init.d/openibd 
# This causes openibd to ignore the kernel difference but relies on weak-updates
# Restarting openibd
/etc/init.d/openibd force-restart
$COMMON_DIR/write_component_version.sh "MOFED" $VERSION

# cleanup downloaded files
rm -rf *.tgz
rm -rf -- */
