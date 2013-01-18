#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing PC/SC, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.chroot/home/user/Desktop/docs/technology/PCSC/
unzip -d ../@config/includes.chroot/home/user/Desktop/docs/technology/PCSC/ download/pcsc1-10_v*.zip
cp download/*.pdf ../@config/includes.chroot/home/user/Desktop/docs/technology/PCSC/
