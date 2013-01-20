#!/bin/bash

mkdir -p config/includes.chroot/root/ config/includes.chroot/etc/skel/
wget -N -P download http://ludovic.rousseau.free.fr/softwares/pcsc-tools/smartcard_list.txt
cp download/smartcard_list.txt config/includes.chroot/root/.smartcard_list.txt
cp download/smartcard_list.txt config/includes.chroot/etc/skel/.smartcard_list.txt
