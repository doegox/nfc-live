#!/bin/bash

# Fetch driver from http://forms.hidglobal.com/driverDownloads.php?techCat=19
# => OMNIKEY 5321 CL USB Reader
# => Linux
# => accept license
# Final URL intercepted in Firefox Live HTTP Headers...

wget -nc -P download http://forms.hidglobal.com/drivers/omnikey/ifdokrfid_lnx_i686-2.10.0.1.tar.gz
