#!/bin/bash

# nfcutils
svn export http://nfc-tools.googlecode.com/svn/trunk/nfcutils nfcutils-dev
cd nfcutils-dev
autoreconf -vis
debian/rules binary
cd ..
mkdir -p /tmp/TRANSFER/app-nfcutils.generated/config/packages.chroot
cp nfcutils*.deb /tmp/TRANSFER/app-nfcutils.generated/config/packages.chroot
cat > /tmp/TRANSFER/app-nfcutils.generated/add.sh <<EOF
#!/bin/bash

mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/app-nfcutils.generated/add.sh

