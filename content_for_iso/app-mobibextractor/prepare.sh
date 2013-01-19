#!/bin/bash

# Originally at http://sites.uclouvain.be/security/mobib.html
wget -nc -P download http://www.hackerzvoice.net/repo_hzv/tools/RFID/MOBIB-Extractor-v1.0.6.zip
unzip download/MOBIB-Extractor-v1.0.6.zip
mkdir -p config/includes.chroot/usr/local/lib/ config/includes.chroot/usr/local/bin/
mv MOBIB-Extractor-v1.0.6 config/includes.chroot/usr/local/lib/mobib-extractor
cd config/includes.chroot/usr/local/lib/mobib-extractor
# Patch for Basic and to use libnfc
patch -p0 < ../../../../../../MOBIB-Extractor.diff
cd -
# Helper
cat > config/includes.chroot/usr/local/bin/MOBIB-Extractor <<EOF
#!/bin/bash

cd /usr/local/lib/mobib-extractor
./MOBIB-Extractor.py
EOF
chmod 755 config/includes.chroot/usr/local/bin/MOBIB-Extractor
# icon
mkdir -p config/includes.chroot/usr/local/share/icons
cp mobib.png config/includes.chroot/usr/local/share/icons/
mkdir -p config/includes.chroot/etc/skel/Desktop
cat > config/includes.chroot/etc/skel/Desktop/mobibextractor.desktop << EOF
[Desktop Entry]
Name=MOBIB-Extractor
Comment=Tool to read MOBIB
Exec=/usr/local/bin/MOBIB-Extractor
Icon=/usr/local/share/icons/mobib.png
Terminal=false
Type=Application
Categories=GNOME;GTK;Utility;
EOF
