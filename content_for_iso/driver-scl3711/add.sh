#!/bin/bash

if [ ! -e download/scx371x_*_linux_32bit.tar.gz ]; then
  echo "SCL3711_driver: Error missing archive scx371x_*_linux_32bit.tar.gz, please run prepare.sh first"
  exit 1
fi
mkdir -p ../@config/includes.chroot/usr/lib/pcsc/drivers/
tar xzf download/scx371x_*_linux_32bit.tar.gz --wildcards --strip-components=2 -C ../@config/includes.chroot/usr/lib/pcsc/drivers/ scx371x_*_linux_32bit/proprietary/SCx371x.bundle
mkdir -p ../@config
rsync -av config/ ../@config
