#!/bin/bash

REVISION=708

svn export -r $REVISION http://proxmark3.googlecode.com/svn/trunk/ proxmark3-dev
cd proxmark3-dev
make client
mkdir -p /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/usr/local/bin
mkdir -p /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/usr/local/share/proxmark3
cp -a traces /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/usr/local/share/proxmark3
cp -a tools/findbits.py tools/rfidtest.pl tools/xorcheck.py /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/usr/local/bin
cd tools/mfkey
make
cp -a mfkey32 mfkey64 /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/usr/local/bin
cd -
cd tools/nonce2key
make
cp -a nonce2key /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/usr/local/bin
cd -
cp -a client/flasher client/proxmark3 /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/usr/local/bin
mkdir -p /tmp/TRANSFER/app-proxmark3.generated/config/includes.binary/nfc-doc/applications/proxmark3
cp doc/*pdf /tmp/TRANSFER/app-proxmark3.generated/config/includes.binary/nfc-doc/applications/proxmark3
# deps
mkdir -p /tmp/TRANSFER/app-proxmark3.generated/config/package-lists
cat > /tmp/TRANSFER/app-proxmark3.generated/config/package-lists/proxmark3-deps.list.chroot <<EOF
libreadline6 libusb-0.1-4 libqtgui4
EOF
cat > /tmp/TRANSFER/app-proxmark3.generated/add.sh <<EOF
#!/bin/bash

mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/app-proxmark3.generated/add.sh
cd ..

# Limited support for Proxmarks with old HID bootrom
REVISION=649
svn export -r $REVISION http://proxmark3.googlecode.com/svn/trunk/ proxmark3-old-dev
cd proxmark3-old-dev
make client
cp -a client/flasher /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/usr/local/bin/flasher-old
# user rights for proxmarks with old HID bootrom
mkdir -p /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/etc/udev/rules.d
cat > /tmp/TRANSFER/app-proxmark3.generated/config/includes.chroot/etc/udev/rules.d/026-proxmark.rules <<EOF
#Proxmark3
SUBSYSTEM=="usb", ATTR{idVendor}=="9ac4", ATTR{idProduct}=="4b8f", MODE="0660", GROUP="plugdev"
EOF
