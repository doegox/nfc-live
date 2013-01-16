#!/bin/bash

if [ ! -e config/includes.chroot ]; then
    echo "Error: missing RFIDIOt files, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config
rsync -av config/ ../@config

