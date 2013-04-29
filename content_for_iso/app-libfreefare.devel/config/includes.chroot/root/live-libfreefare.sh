#!/bin/bash

REVISION=00e999dd523b6f2be8b7820f3797b4ec9fd6c88a

git clone http://code.google.com/p/libfreefare/ libfreefare-dev
cd libfreefare-dev
git checkout $REVISION

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

