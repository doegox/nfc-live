#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing NXP docs, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.chroot/home/user/Desktop/docs/products/NXP/
rsync -av download/ ../@config/includes.chroot/home/user/Desktop/docs/products/NXP/
