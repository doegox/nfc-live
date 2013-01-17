#!/bin/bash

# Fetch driver from http://www.identive-infrastructure.com/support_tmp/download.php?file=latestLinSCL37xx
# => http://www.identive-infrastructure.com/products-solutions/smart-card-readers-a-terminals/contactless-readers/scl3711#downloads
# => wget --trust-server-names "http://www.identive-infrastructure.com/support_tmp/download.php?file=latestLinSCL37xx"
# => final URL is http://www.identive-infrastructure.com/support/download/scx371x_2.11_linux_32bit.tar.gz

wget -nc http://www.identive-infrastructure.com/support/download/scx371x_2.11_linux_32bit.tar.gz
