#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing SCL3711 docs, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.chroot/home/user/Desktop/docs/products/SCL3711/
rsync -av download/ ../@config/includes.chroot/home/user/Desktop/docs/products/SCL3711/

