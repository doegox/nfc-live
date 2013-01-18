#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing NFC-Forum docs, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.chroot/home/user/Desktop/docs/technology/NFC-Forum
rsync -av download/ ../@config/includes.chroot/home/user/Desktop/docs/technology/NFC-Forum/
