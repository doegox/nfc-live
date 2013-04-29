#!/bin/bash

REVISION=41ec6d49f6f21e96412f948a26e7ff368beb9d28
git clone http://code.google.com/p/libnfc/ libnfc-dev

cd libnfc-dev
git checkout $REVISION

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
