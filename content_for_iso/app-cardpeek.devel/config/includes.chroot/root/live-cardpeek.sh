#!/bin/bash

REVISION=334

svn export -r $REVISION http://cardpeek.googlecode.com/svn/trunk/ cardpeek-dev
cd cardpeek-dev
autoreconf -vis
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
mkdir -p /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/usr/local/share/icons
wget -O /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/usr/local/share/icons/cardpeek.png "https://code.google.com/p/cardpeek/logo"
mkdir -p /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/etc/skel/Desktop
cat > /tmp/TRANSFER/app-cardpeek.generated/config/includes.chroot/etc/skel/Desktop/cardpeek.desktop << EOF
[Desktop Entry]
Name=Cardpeek
Comment=Tool to read the contents of smart cards
Exec=/usr/local/bin/cardpeek
Icon=/usr/local/share/icons/cardpeek.png
Terminal=false
Type=Application
Categories=GNOME;GTK;Utility;
EOF
mkdir -p /tmp/TRANSFER/app-cardpeek.generated/config/package-lists
echo "liblua5.1-0 libssl1.0.0 libgtk2.0-0" > /tmp/TRANSFER/app-cardpeek.generated/config/package-lists/cardpeek-deps.list.chroot
cat > /tmp/TRANSFER/app-cardpeek.generated/add.sh <<EOF
#!/bin/bash

chmod +x config/includes.chroot/usr/local/bin/cardpeek
mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/app-cardpeek.generated/add.sh
