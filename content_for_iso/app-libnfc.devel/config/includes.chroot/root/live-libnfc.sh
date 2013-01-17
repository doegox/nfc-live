#!/bin/bash

REVISION=2fbf5ab7416954592c7d8edc8651677c28c632bc

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
cat > /tmp/TRANSFER/app-libnfc.generated/add.sh <<EOF
#!/bin/bash

mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/app-libnfc.generated/add.sh
