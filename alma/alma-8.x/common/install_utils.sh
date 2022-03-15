#!/bin/bash
set -ex

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
    texinfo \
    glibc-devel \
    glibc-static \
    libudev-devel \
    binutils \
    binutils-devel \
    selinux-policy-devel \
    kernel-headers \
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
    kernel-rpm-macros \
    kernel-modules-extra \
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
