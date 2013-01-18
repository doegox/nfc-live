#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing NXP docs, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.binary/nfc-doc/products/NXP/
rsync -av download/ ../@config/includes.binary/nfc-doc/products/NXP/
