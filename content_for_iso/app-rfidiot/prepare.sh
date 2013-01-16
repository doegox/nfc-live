#!/bin/bash

git clone --depth 1 --branch for_libnfc_170 https://github.com/doegox/RFIDIOt.git
cd RFIDIOt
mkdir -p ../config/includes.chroot
python setup.py install --root ../config/includes.chroot
cd ..
rm -rf RFIDIOt
mkdir -p config/includes.chroot/home/user/Desktop/docs/applications/rfidiot/
wget -O config/includes.chroot/home/user/Desktop/docs/applications/rfidiot/documentation.html http://rfidiot.org/documentation.html
mkdir -p config/includes.chroot/etc/
echo "-R READER_LIBNFC" > config/includes.chroot/etc/RFIDIOtconfig.opts
