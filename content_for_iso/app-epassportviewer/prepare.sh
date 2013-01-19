#!/bin/bash

# sudo apt-get install python-dev python-setuptools

# epassportviewer 2.0.14
VERSION=2.0.14
mkdir -p download
wget -nc -O download/ePassportViewer-$VERSION.tar.gz "http://ge.tt/api/1/files/6Exz0YO/2/blob?download"
mkdir -p config/includes.chroot/usr/local/lib
tar xzf download/ePassportViewer-$VERSION.tar.gz --strip-components=1 -C config/includes.chroot/usr/local/lib ePassportViewer-2.0.14/ePassportViewer-2.0
rm -rf config/includes.chroot/usr/local/lib/ePassportViewer-2.0/geojasper
tar xzf certificates.tgz -C config/includes.chroot/usr/local/lib/ePassportViewer-2.0/epassportviewer/ressources/
tar xzf download/ePassportViewer-$VERSION.tar.gz --strip-components=2 -C config/includes.chroot/usr/local/lib/ePassportViewer-2.0 ePassportViewer-2.0.14/pypassport-2.0/pypassport
# patches
cd config/includes.chroot/usr/local/lib/ePassportViewer-2.0
patch -p2 < ../../../../../../ePV.diff
cd -

# cleaning & fixing rights
find config/includes.chroot/usr/local/lib/ePassportViewer-2.0 -name "*.pyc" -or -name "*~" -exec rm {} \;
find config/includes.chroot/usr/local/lib/ePassportViewer-2.0 -type d -exec chmod 755 {} \;
find config/includes.chroot/usr/local/lib/ePassportViewer-2.0 -type f -exec chmod 644 {} \;

# epassportviewer helper
mkdir -p config/includes.chroot/usr/local/bin
cat > config/includes.chroot/usr/local/bin/ePassportViewer << EOF
#!/bin/bash
python /usr/local/lib/ePassportViewer-2.0/ePassportViewer.py
EOF
chmod 755 config/includes.chroot/usr/local/bin/ePassportViewer
# icon
mkdir -p config/includes.chroot/usr/local/share/icons
wget -nc -O download/epassportviewer.png "https://code.google.com/p/epassportviewer/logo"
cp download/epassportviewer.png config/includes.chroot/usr/local/share/icons/
mkdir -p config/includes.chroot/etc/skel/Desktop
cat > config/includes.chroot/etc/skel/Desktop/epassportviewer.desktop << EOF
[Desktop Entry]
Name=ePassportViewer
Comment=Tool to read and check ePassports
Exec=/usr/local/bin/ePassportViewer
Icon=/usr/local/share/icons/epassportviewer.png
Terminal=false
Type=Application
Categories=GNOME;GTK;Utility;
EOF

# JOHN DOE history
mkdir -p config/includes.chroot/root config/includes.chroot/etc/skel
tee config/includes.chroot/root/.ePV-history > config/includes.chroot/etc/skel/.ePV-history << EOF
(lp0
(S'DOE JOHN'
p1
S'EH123456<0BEL7001017M1301162<<<<<<<<<<<<<<02'
p2
tp3
a.
EOF
# Min config with CSCA
tee config/includes.chroot/root/.ePV-config.ini > config/includes.chroot/etc/skel/.ePV-config.ini << EOF
[Security]
aa = 1
pa = 1

[Options]
certificate = /usr/local/lib/ePassportViewer-2.0/epassportviewer/ressources/certificates
driver = PcscReader
openssl = openssl
reader = Auto
path = 
disclamer = 0

[Logs]
api = 1
apdu = 1
sm = 1
bac = 1
EOF

# pypassport doc
#mkdir -p config/includes.binary/nfc-doc/applications/epassportviewer
#wget -nc -P download http://pypassport.googlecode.com/files/pypassport-1.0-doc.zip
# epassportviewer doc
#unzip -d config/includes.binary/nfc-doc/applications/epassportviewer download/pypassport-1.0-doc.zip
#wget -nc -P download http://epassportviewer.googlecode.com/files/epassportviewer-0.2c.manual.pdf
#cp -a download/epassportviewer-0.2c.manual.pdf config/includes.binary/nfc-doc/applications/epassportviewer 

# geojasper
wget -nc -P download http://www.dimin.net/software/geojasper/geojasper_linux32.tgz
mkdir -p config/includes.chroot/usr/local/bin
tar xzf download/geojasper_linux32.tgz --strip-components=1 -C config/includes.chroot/usr/local/bin geojasper/geojasper
chmod 755 config/includes.chroot/usr/local/bin/geojasper
