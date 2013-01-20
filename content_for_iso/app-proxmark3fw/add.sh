#!/bin/bash

if [ ! -e config/includes.chroot/usr/local/share/proxmark3/firmware_* ]; then
  echo "Error: missing Proxmark firmware, please read howto.txt"
  exit 1
fi

mkdir -p ../@config
rsync -av config/ ../@config
