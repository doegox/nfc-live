#!/bin/bash

REVISION=fe7faf7a74769976f0b034578beffde39f74f8e6

git clone http://code.google.com/p/ifdnfc/ ifdnfc-dev
cd ifdnfc-dev
git checkout $REVISION
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
sed -i -e '/0x04E6\|0x5591\|SCL3711/s/\(.*\)/<!-- \1 -->/' /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/Info.plist
# Provide helper scripts
mkdir -p /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/bin/
cat > /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/bin/scl3711-pcsc_proprio << EOF
#!/bin/bash

sudo /etc/init.d/pcscd stop
# comment out SCL3711 from ifdnfc
sudo sed -i -e '/^[[:space:]]*<string>\(0x04E6\|0x5591\|SCM\)/s/\(.*\)/<!-- \1 -->/' /usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/Info.plist
# activate SCL3711 proprietary driver
sudo mv /usr/lib/pcsc/drivers/SCx371x.bundle/Contents/Info.plist.disabled /usr/lib/pcsc/drivers/SCx371x.bundle/Contents/Info.plist 2>/dev/null
sudo /etc/init.d/pcscd start
EOF
cat > /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/bin/scl3711-pcsc_ifdnfc << EOF
#!/bin/bash

sudo /etc/init.d/pcscd stop
# add SCL3711 to ifdnfc
sudo sed -i -e '/^<!--[[:space:]]*<string>\(0x04E6\|0x5591\|SCM\)/s/<!-- //;s/ -->//' /usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/Info.plist
# deactivate SCL3711 proprietary driver
sudo mv /usr/lib/pcsc/drivers/SCx371x.bundle/Contents/Info.plist /usr/lib/pcsc/drivers/SCx371x.bundle/Contents/Info.plist.disabled 2>/dev/null
sudo /etc/init.d/pcscd start
EOF
cat > /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/bin/scl3711-libnfc << EOF
#!/bin/bash

sudo /etc/init.d/pcscd stop
# comment out SCL3711 from ifdnfc
sudo sed -i -e '/^[[:space:]]*<string>\(0x04E6\|0x5591\|SCM\)/s/\(.*\)/<!-- \1 -->/' /usr/lib/pcsc/drivers/ifdnfc.bundle/Contents/Info.plist
# deactivate SCL3711 proprietary driver
sudo mv /usr/lib/pcsc/drivers/SCx371x.bundle/Contents/Info.plist /usr/lib/pcsc/drivers/SCx371x.bundle/Contents/Info.plist.disabled 2>/dev/null
sudo /etc/init.d/pcscd start
EOF
chmod 755 /tmp/TRANSFER/driver-ifdnfc.generated/config/includes.chroot/usr/local/bin/*
