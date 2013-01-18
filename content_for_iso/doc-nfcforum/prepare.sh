#!/bin/bash

wget -nc -P download http://www.adafruit.com/datasheets/Introduction_to_NFC_v1_0_en.pdf
cat > download/readme.txt << EOF
NFC-Forum specs are freely available after clickthrough license.
See http://www.nfc-forum.org/specs/spec_license to get your copy.
EOF
