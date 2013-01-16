#!/bin/bash

# epassportviewer
svn export http://epassportviewer.googlecode.com/svn/trunk/epassportviewer/src/epassportviewer config/includes.chroot/usr/local/lib/epassportviewer/epassportviewer
mv config/includes.chroot/usr/local/lib/epassportviewer/epassportviewer/ePassportViewer.py config/includes.chroot/usr/local/lib/epassportviewer/
# pypassport
svn export http://pypassport.googlecode.com/svn/trunk/pypassport/src/pypassport config/includes.chroot/usr/local/lib/epassportviewer/pypassport
# fix epassportviewer temp files location
cd config/includes.chroot/usr/local/lib/
patch -p0 <<EOF
diff -Naur epassportviewer/epassportviewer/const.py epassportviewer/epassportviewer/const.py
--- epassportviewer/epassportviewer/const.py	2010-03-25 01:36:37.000000000 +0100
+++ epassportviewer/epassportviewer/const.py	2011-05-28 23:45:46.000000000 +0200
@@ -22,10 +22,10 @@
 DEBUG   = True
 STDERR  = 'error.log'
 CONFIG  = 'config.ini'
-HISTORY = 'history'
+HISTORY = '/tmp/epp-history'
 MAX_HISTORY = 10
 TITLE   = 'ePassport Viewer'
-LOG     = 'system.log'
+LOG     = '/tmp/epp-system.log'
 
 VERSION = '1.0'
 WEBSITE = "http://code.google.com/p/epassportviewer/"
diff -Naur epassportviewer/ePassportViewer.py epassportviewer/ePassportViewer.py
--- epassportviewer/ePassportViewer.py	2010-03-25 01:36:34.000000000 +0100
+++ epassportviewer/ePassportViewer.py	2011-05-28 23:46:20.000000000 +0200
@@ -33,7 +33,7 @@
 class dummyStream(object):
     ''' dummyStream behaves like a stream but does nothing. '''
     def __init__(self): 
-        self.f = open('out.txt', 'w')
+        self.f = open('/tmp/epp-out.txt', 'w')
     def write(self,data): 
         self.f.write(data)
     def read(self,data): pass
EOF
cd -
# fix pypassport DES3 IV
cd config/includes.chroot/usr/local/lib/epassportviewer
patch -p3 < ../../../../../../pypassport-des3-iv.patch
cd -
# epassportviewer helper
mkdir -p config/includes.chroot/usr/local/bin
cat > config/includes.chroot/usr/local/bin/ePassportViewer << EOF
#!/bin/bash
cd /usr/local/lib/epassportviewer
python ePassportViewer.py
EOF
# geojasper
wget -O - http://www.dimin.net/software/geojasper/geojasper_linux32.tgz|tar xz --strip-components=1 -C config/includes.chroot/usr/local/bin geojasper/geojasper
chmod 755 config/includes.chroot/usr/local/bin/*
# pypassport doc
mkdir -p config/includes.chroot/home/user/Desktop/docs/applications/epassportviewer
wget -nc http://pypassport.googlecode.com/files/pypassport-1.0-doc.zip
# epassportviewer doc
unzip -d config/includes.chroot/home/user/Desktop/docs/applications/epassportviewer pypassport-1.0-doc.zip
wget -nc -P config/includes.chroot/home/user/Desktop/docs/applications/epassportviewer http://epassportviewer.googlecode.com/files/epassportviewer-0.2c.manual.pdf
