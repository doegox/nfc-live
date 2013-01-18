#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing ACS docs, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.chroot/home/user/Desktop/docs/products/ACS/
rsync -av download/ ../@config/includes.chroot/home/user/Desktop/docs/products/ACS/

