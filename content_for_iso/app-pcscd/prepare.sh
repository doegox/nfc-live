#!/bin/bash

mkdir -p config/includes.chroot/root/ config/includes.chroot/etc/skel/
wget -nc -O config/includes.chroot/root/.smartcard_list.txt http://ludovic.rousseau.free.fr/softwares/pcsc-tools/smartcard_list.txt
cp config/includes.chroot/root/.smartcard_list.txt config/includes.chroot/etc/skel/.smartcard_list.txt
