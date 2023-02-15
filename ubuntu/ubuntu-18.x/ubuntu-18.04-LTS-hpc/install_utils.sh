#!/bin/bash
set -ex

AZCOPY_VERSION="10.16.2"
AZCOPY_RELEASE_TAG="release20221108"
$UBUNTU_COMMON_DIR/install_utils.sh ${AZCOPY_VERSION} ${AZCOPY_RELEASE_TAG}
apt-get -y install python-dev
