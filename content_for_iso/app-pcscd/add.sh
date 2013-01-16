#!/bin/bash

if [ ! -e config/includes.chroot/root/.smartcard_list.txt ]; then
  echo "Error: no smartcard_list.txt file, please run prepare.sh first"
  exit 1
fi
mkdir -p ../@config
rsync -av config/ ../@config
