#!/bin/bash
set -ex

# Load gcc
GCC_VERSION=gcc-9.2.0
export PATH=/opt/${GCC_VERSION}/bin:$PATH
export LD_LIBRARY_PATH=/opt/${GCC_VERSION}/lib64:$LD_LIBRARY_PATH
set CC=/opt/${GCC_VERSION}/bin/gcc
set GCC=/opt/${GCC_VERSION}/bin/gcc


INSTALL_PREFIX=/opt

# HPC-X v2.8.3
HPCX_VERSION="v2.8.3"
HPCX_DOWNLOAD_URL=https://azhpcstor.blob.core.windows.net/azhpc-images-store/hpcx-v2.8.3-gcc-MLNX_OFED_LINUX-5.2-2.2.3.0-redhat8.1-x86_64.tbz
TARBALL=$(basename ${HPCX_DOWNLOAD_URL})
HPCX_FOLDER=$(basename ${HPCX_DOWNLOAD_URL} .tbz)

$COMMON_DIR/download_and_verify.sh $HPCX_DOWNLOAD_URL "634aa92e01174c0cd9c5f7f549b80a693103432d48bbaf0cd942a7de2adb9362"
tar -xvf ${TARBALL}
mv ${HPCX_FOLDER} ${INSTALL_PREFIX}
HPCX_PATH=${INSTALL_PREFIX}/${HPCX_FOLDER}

# Enable Sharpd
sudo /opt/hpcx-${HPCX_VERSION}-gcc-MLNX_OFED_LINUX-5.2-2.2.3.0-redhat8.1-x86_64/sharp/sbin/sharp_daemons_setup.sh -s -d sharpd
sudo systemctl enable sharpd
sudo systemctl start sharpd

# Setup module files for MPIs
mkdir -p /usr/share/Modules/modulefiles/mpi/

# HPC-X
cat << EOF >> /usr/share/Modules/modulefiles/mpi/hpcx-${HPCX_VERSION}
#%Module 1.0
#
#  HPCx ${HPCX_VERSION}
#
conflict        mpi
module load ${HPCX_PATH}/modulefiles/hpcx
EOF

# Create symlinks for modulefiles
ln -s /usr/share/Modules/modulefiles/mpi/hpcx-${HPCX_VERSION} /usr/share/Modules/modulefiles/mpi/hpcx

# Install platform independent MPIs
../../common/install_mpis.sh ${GCC_VERSION} ${HPCX_PATH}
