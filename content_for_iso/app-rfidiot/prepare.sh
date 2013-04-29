#!/bin/bash

REVISION=66584be0f127da4dfa6bc9dc80f77884b9d37362

git clone --depth 1 --branch master https://github.com/AdamLaurie/RFIDIOt.git
cd RFIDIOt
git checkout $REVISION
# Little patch to increase default libnfc timeout
#sed -i '/transceive_bytes/s/-1/4000/' rfidiot/pynfc.py

mkdir -p ../config/includes.chroot
python setup.py install --root ../config/includes.chroot
cd ..
rm -rf RFIDIOt
mkdir -p config/includes.binary/nfc-doc/applications/rfidiot/
wget -O config/includes.binary/nfc-doc/applications/rfidiot/documentation.html http://rfidiot.org/documentation.html
mkdir -p config/includes.chroot/etc/
echo "-R READER_LIBNFC" > config/includes.chroot/etc/RFIDIOtconfig.opts
