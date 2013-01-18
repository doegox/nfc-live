#!/bin/bash

REVISION=88ec1f6ea593de3c0ffb23f38a0216ed23ef7a1b

git clone --depth 1 --branch devel https://github.com/doegox/RFIDIOt.git
cd RFIDIOt
git checkout $REVISION
mkdir -p ../config/includes.chroot
python setup.py install --root ../config/includes.chroot
cd ..
rm -rf RFIDIOt
mkdir -p config/includes.binary/nfc-doc/applications/rfidiot/
wget -O config/includes.binary/nfc-doc/applications/rfidiot/documentation.html http://rfidiot.org/documentation.html
mkdir -p config/includes.chroot/etc/
echo "-R READER_LIBNFC" > config/includes.chroot/etc/RFIDIOtconfig.opts
