#!/bin/bash

# example dumps
mkdir -p config/includes.chroot/home/user/Desktop/docs/
svn export http://nfc-tools.googlecode.com/svn/trunk/dumps config/includes.chroot/home/user/Desktop/docs/dumps

# sniff-pn53x.sh
mkdir -p config/includes.chroot/usr/local/bin/
svn export http://nfc-tools.googlecode.com/svn/trunk/dev-tools/sniff-pn53x.sh config/includes.chroot/usr/local/bin/sniff-pn53x.sh
