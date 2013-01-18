#!/bin/bash

if [ ! -e download ]; then
    echo "Error: missing ACS docs, please run prepare.sh first"
    exit 1
fi
mkdir -p ../@config/includes.binary/nfc-doc/products/ACS/
rsync -av download/ ../@config/includes.binary/nfc-doc/products/ACS/

