#!/bin/bash
set -ex

yum install -y python3-dnf-plugin-versionlock
dnf versionlock add kernel
echo "exclude=kernel" >> /etc/dnf/dnf.conf

#yum install -y https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-headers-4.18.0-348.12.2.el8_5.x86_64.rpm
#yum install -y https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-rpm-macros-4.18.0-348.12.2.el8_5.x86_64.rpm
#yum install -y --skip-broken https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-modules-extra-4.18.0-348.12.2.el8_5.x86_64.rpm
yum install -y https://vault.centos.org/centos/8/AppStream/x86_64/os/Packages/kernel-rpm-macros-125-1.el8.noarch.rpm
yum install -y https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-headers-4.18.0-348.20.1.el8_5.x86_64.rpm
yum install -y https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-modules-extra-4.18.0-348.20.1.el8_5.x86_64.rpm
yum install -y https://repo.almalinux.org/almalinux/8.5/BaseOS/x86_64/os/Packages/kernel-devel-4.18.0-348.20.1.el8_5.x86_64.rpm

# Install pre-reqs and development tools
yum groupinstall -y "Development Tools"
yum install -y numactl \
    numactl-devel \
    libxml2-devel \
    byacc \
    environment-modules \
    python3-devel \
    python3-setuptools \
    gtk2 \
    atk \
    cairo \
    tcl \
    tk \
    m4 \
    glibc-devel \
    libudev-devel \
    binutils \
    binutils-devel \
    selinux-policy-devel \
    nfs-utils \
    fuse-libs \
    libpciaccess \
    cmake \
    libnl3-devel \
    libsecret \
    https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/d/dkms-3.0.3-1.el8.noarch.rpm \
    rpm-build \
    make \
    check \
    check-devel \
    https://cbs.centos.org/kojifiles/packages/subunit/1.4.0/1.el8/x86_64/subunit-1.4.0-1.el8.x86_64.rpm \
    https://cbs.centos.org/kojifiles/packages/subunit/1.4.0/1.el8/x86_64/subunit-devel-1.4.0-1.el8.x86_64.rpm \
    lsof \
    tcsh \
    gcc-gfortran
    
# Install azcopy tool 
# To copy blobs or files to or from a storage account.
wget https://azhpcstor.blob.core.windows.net/azhpc-images-store/azcopy_linux_se_amd64_10.12.2.tar.gz
tar -xvf azcopy_linux_se_amd64_10.12.2.tar.gz

# copy the azcopy to the bin path
pushd azcopy_linux_se_amd64_10.12.2
cp azcopy /usr/bin/
popd

# Allow execute permissions
chmod +x /usr/bin/azcopy
