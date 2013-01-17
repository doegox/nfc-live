#!/bin/bash

REVISION=8885aaa94c6a80283fddc7712783bd44dbf3de27

git clone http://code.google.com/p/libfreefare/ libfreefare-dev
cd libfreefare-dev
git checkout $REVISION
# MAX_FRAME_SIZE hack
patch -p1 < ../libfreefare-DF_max_buffer_size_hack.diff
autoreconf -vis
debian/rules binary
cd ..
mkdir -p /tmp/TRANSFER/app-libfreefare.generated/config/package-lists
echo "libssl1.0.0" > /tmp/TRANSFER/app-libfreefare.generated/config/package-lists/libfreefare-deps.list.chroot
mkdir -p /tmp/TRANSFER/app-libfreefare.generated/config/packages.chroot
cp libfreefare*.deb /tmp/TRANSFER/app-libfreefare.generated/config/packages.chroot
cat > /tmp/TRANSFER/app-libfreefare.generated/add.sh <<EOF
#!/bin/bash

mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/app-libfreefare.generated/add.sh

