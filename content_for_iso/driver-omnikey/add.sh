#!/bin/bash

if [ ! -e download/ifdokrfid_lnx_i686-*.tar.gz ]; then
  echo "Omnikey_driver: Error missing archive ifdokrfid_lnx_i686-*.tar.gz, please run prepare.sh first"
  exit 1
fi
mkdir -p ../@config/includes.chroot/etc/
mkdir -p ../@config/includes.chroot/usr/lib/pcsc/drivers/
tar xzf download/ifdokrfid_lnx_i686-*.tar.gz --wildcards --strip-components=2 -C ../@config/includes.chroot/usr/lib/pcsc/drivers/ ./ifdokrfid_lnx_i686*/ifdokrfid_lnx_i686-*.bundle/
tar xzf download/ifdokrfid_lnx_i686-*.tar.gz --wildcards --strip-components=2 -C ../@config/includes.chroot/etc/ ./ifdokrfid_lnx_i686*/cmrfid.ini
