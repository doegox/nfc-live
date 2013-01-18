#!/bin/bash

REVISION=208

svn export -r $REVISION http://cardpeek.googlecode.com/svn/trunk/ cardpeek-dev
cd cardpeek-dev
./configure
make
mkdir -p /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/usr/local/bin
cp -a cardpeek /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/usr/local/bin
mkdir -p /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/usr/local/share/man/man1
cp -a cardpeek.1 /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/usr/local/share/man/man1
mkdir -p /tmp/TRANSFER/app-cardpeek.generated/config/includes.binary/nfc-doc/applications/cardpeek
cp -a doc/cardpeek_ref.en.pdf /tmp/TRANSFER/app-cardpeek.generated/config/includes.binary/nfc-doc/applications/cardpeek
mkdir -p /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/root/.cardpeek
cp -a dot_cardpeek_dir/* /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/root/.cardpeek
mkdir -p /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/etc/skel/.cardpeek
cp -a dot_cardpeek_dir/* /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/etc/skel/.cardpeek
echo "liblua5.1-0 libssl1.0.0 libgtk2.0-0" > /tmp/TRANSFER/app-cardpeek.generated/config/package-lists/cardpeek-deps.list.chroot
cat > /tmp/TRANSFER/app-cardpeek.generated/add.sh <<EOF
#!/bin/bash

chmod +x config/includes.chroot/usr/local/bin/cardpeek
mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/app-cardpeek.generated/add.sh
