#!/bin/bash

REVISION=4576bad36972b8f19e6e330355d95367a4e18400
#!!+merge see below
git clone http://code.google.com/p/libnfc/ libnfc-dev

cd libnfc-dev
git checkout $REVISION
# TEMP merge test_user_defined_device_optional:
git merge --no-commit 04a7d2a3ba85c01f1c9f28a0626318e6bbf7c3b0

debian/rules binary
mkdir -p /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/etc/modprobe.d
cp contrib/linux/blacklist-libnfc.conf /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/etc/modprobe.d
mkdir -p /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/usr/local/bin/
cp examples/pn53x-tamashell-scripts/ReadMobib.sh /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/usr/local/bin/
chmod 755 /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/usr/local/bin/ReadMobib.sh
cp examples/pn53x-tamashell-scripts/ReadNavigo.sh /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/usr/local/bin/
chmod 755 /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/usr/local/bin/ReadNavigo.sh
cd ..
dpkg -i libnfc*deb
mkdir -p /tmp/TRANSFER/app-libnfc.generated/config/packages.chroot
cp libnfc*.deb /tmp/TRANSFER/app-libnfc.generated/config/packages.chroot
mkdir -p /tmp/TRANSFER/app-libnfc.generated/config/package-lists
echo "libusb-0.1-4 libpcsclite1 libreadline6" > /tmp/TRANSFER/app-libnfc.generated/config/package-lists/libnfc-deps.list.chroot
mkdir -p /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/etc/nfc/devices.d/
cat > /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/etc/nfc/devices.d/openpcd2.conf <<EOF
name = "OpenPCD2"
connstring = "pn532_uart:/dev/ttyACM0"
optional = true
EOF
cat > /tmp/TRANSFER/app-libnfc.generated/add.sh <<EOF
#!/bin/bash

mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/app-libnfc.generated/add.sh
