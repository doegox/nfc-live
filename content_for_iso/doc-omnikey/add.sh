#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing Omnikey docs, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.chroot/home/user/Desktop/docs/products/OmniKey5321/
rsync -av download/ ../@config/includes.chroot/home/user/Desktop/docs/products/OmniKey5321/

