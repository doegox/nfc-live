#!/bin/bash

git clone http://code.google.com/p/libnfc/ libnfc-dev

cd libnfc-dev
debian/rules binary
mkdir -p /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/etc/modprobe.d
cp contrib/linux/blacklist-libnfc.conf /tmp/TRANSFER/app-libnfc.generated/config/includes.chroot/etc/modprobe.d
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
