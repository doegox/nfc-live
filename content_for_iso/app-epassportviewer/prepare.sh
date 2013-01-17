#!/bin/bash

# sudo apt-get install python-dev python-setuptools

# epassportviewer 2.0.14
VERSION=2.0.14
wget -nc -O ePassportViewer-$VERSION.tar.gz "http://ge.tt/api/1/files/6Exz0YO/2/blob?download"
mkdir -p config/includes.chroot/usr/local/lib
tar xzf ePassportViewer-$VERSION.tar.gz --strip-components=1 -C config/includes.chroot/usr/local/lib ePassportViewer-2.0.14/ePassportViewer-2.0
rm -rf config/includes.chroot/usr/local/lib/ePassportViewer-2.0/geojasper
# patch upper()
cd config/includes.chroot/usr/local/lib/ePassportViewer-2.0
patch -p0 <<EOF
--- epassportviewer/util/forge.py	2012-08-01 11:13:39.000000000 +0200
+++ epassportviewer/util/forge.py	2013-01-16 23:19:30.457200482 +0100
@@ -105,7 +105,7 @@
         # Full name
         if middle_name:
             middle_name = middle_name.replace(' ', '<')
-            full_name = surname.uppercase + "<<" + firstname.uppercase + middle_name.uppercase
+            full_name = surname.upper() + "<<" + firstname.upper() + middle_name.upper()
             dgc.addDataObject("5F02", full_name)
          
         # Place of birth
EOF
# fix epassportviewer temp files location
patch -p0 <<EOF
--- epassportviewer/const.py	2012-08-22 10:31:44.000000000 +0200
+++ epassportviewer/const.py	2013-01-17 01:23:15.679957082 +0100
@@ -20,12 +20,12 @@
 
 # Options
 DEBUG   = True
-STDERR  = 'error.log'
-CONFIG  = 'config.ini'
-HISTORY = 'history'
+STDERR  = '/tmp/ePV-error.log'
+CONFIG  = '/tmp/ePV-config.ini'
+HISTORY = '/tmp/ePV-history'
 MAX_HISTORY = 10
 TITLE   = 'ePassport Viewer'
-LOG     = 'system.log'
+LOG     = '/tmp/ePV-system.log'
 
 VERSION = '2.0'
 WEBSITE = "http://code.google.com/p/epassportviewer/"
--- ePassportViewer.py	2012-08-09 16:56:00.000000000 +0200
+++ ePassportViewer.py	2013-01-17 01:22:42.559357140 +0100
@@ -35,7 +35,7 @@
 class dummyStream(object):
     ''' dummyStream behaves like a stream but does nothing. '''
     def __init__(self): 
-        self.f = open('out.txt', 'w')
+        self.f = open('/tmp/ePV-out.txt', 'w')
     def write(self,data): 
         self.f.write(data)
     def read(self,data): pass
EOF
cd -
tar xzf ePassportViewer-$VERSION.tar.gz --strip-components=2 -C config/includes.chroot/usr/local/lib/ePassportViewer-2.0 ePassportViewer-2.0.14/pypassport-2.0/pypassport

# cleaning
find config/includes.chroot/usr/local/lib/ePassportViewer-2.0 -name "*.pyc" -or -name "*~" -exec rm {} \;

# epassportviewer helper
mkdir -p config/includes.chroot/usr/local/bin
cat > config/includes.chroot/usr/local/bin/ePassportViewer << EOF
#!/bin/bash
python /usr/local/lib/ePassportViewer-2.0/ePassportViewer.py
EOF
chmod 755 config/includes.chroot/usr/local/bin/ePassportViewer

# JOHN DOE history
cat > config/includes.chroot/tmp/ePV-history << EOF
(lp0
(S'DOE JOHN'
p1
S'EH123456<0BEL7001017M1301162<<<<<<<<<<<<<<02'
p2
tp3
a.
EOF

# pypassport doc
#mkdir -p config/includes.chroot/home/user/Desktop/docs/applications/epassportviewer
#wget -nc http://pypassport.googlecode.com/files/pypassport-1.0-doc.zip
# epassportviewer doc
#unzip -d config/includes.chroot/home/user/Desktop/docs/applications/epassportviewer pypassport-1.0-doc.zip
#wget -nc -P config/includes.chroot/home/user/Desktop/docs/applications/epassportviewer http://epassportviewer.googlecode.com/files/epassportviewer-0.2c.manual.pdf

# geojasper
wget -nc http://www.dimin.net/software/geojasper/geojasper_linux32.tgz
mkdir -p config/includes.chroot/usr/local/bin
tar xzf geojasper_linux32.tgz --strip-components=1 -C config/includes.chroot/usr/local/bin geojasper/geojasper
chmod 755 config/includes.chroot/usr/local/bin/geojasper

