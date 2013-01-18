#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing SCL3711 docs, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.binary/nfc-doc/products/SCL3711/
rsync -av download/ ../@config/includes.binary/nfc-doc/products/SCL3711/

