#!/bin/bash

AOCC_VERSION=4.1.0_1

# install dependency
wget https://download.amd.com/developer/eula/aocc/aocc-4-1/aocc-compiler-${AOCC_VERSION}_amd64.deb
apt install -y ./aocc-compiler-${AOCC_VERSION}_amd64.deb

rm aocc-compiler-${AOCC_VERSION}_amd64.deb 

$COMMON_DIR/write_component_version.sh "AOCC" ${AOCC_VERSION}
