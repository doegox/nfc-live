#!/bin/bash

git clone http://code.google.com/p/ifdnfc/ ifdnfc-dev
cd ifdnfc-dev
autoreconf -vis
./configure
make
mkdir -p /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/Linux/
cp src/Info.plist /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/
cp src/.libs/libifdnfc.so /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/Linux/libifdnfc.so.0.1.4
mkdir -p /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/etc/reader.conf.d
sed "s#TARGETNAME#`awk '/IFDNFC_READER_NAME/ {print $3}' src/ifd-nfc.h`#;\
        s#TARGETPATH#/usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/Linux/libifdnfc.so.0.1.4#"   src/reader.conf.in \
                > /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/etc/reader.conf.d/ifdnfc
mkdir -p /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/bin
cp src/ifdnfc-activate /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/bin
chmod +x /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/bin/ifdnfc-activate
cd ..
cat > /tmp/TRANSFER/driver-ifdnfc.generated/add.sh <<EOF
#!/bin/bash

mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/driver-ifdnfc.generated/add.sh
# Avoid conflict with SCL3711 driver:
sed -i -e '/0x04E6/d;/0x5591/d;/SCL3711/d' /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/Info.plist
