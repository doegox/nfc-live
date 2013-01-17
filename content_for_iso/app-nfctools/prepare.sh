#!/bin/bash

REVISION=1116

# example dumps
mkdir -p config/includes.chroot/home/user/Desktop/docs/
svn export -r $REVISION http://nfc-tools.googlecode.com/svn/trunk/dumps config/includes.chroot/home/user/Desktop/docs/dumps

# sniff-pn53x.sh
mkdir -p config/includes.chroot/usr/local/bin/
svn export -r $REVISION http://nfc-tools.googlecode.com/svn/trunk/dev-tools/sniff-pn53x.sh config/includes.chroot/usr/local/bin/sniff-pn53x.sh
