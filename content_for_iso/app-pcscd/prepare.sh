#!/bin/bash

mkdir -p config/includes.chroot/root/
wget -nc -O config/includes.chroot/root/.smartcard_list.txt http://ludovic.rousseau.free.fr/softwares/pcsc-tools/smartcard_list.txt
