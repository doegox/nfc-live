#!/bin/bash

svn export http://svn.gnumonks.org/trunk/librfid/ librfid-dev
cd librfid-dev
autoreconf -vis
./configure --enable-ccid --disable-shared --prefix=/tmp/TRANSFER/app-librfid.generated/config/includes.chroot/usr/local/
make
make install
patch -p0 < ../librfid_rfid_layer2_iso15693.diff
make
for i in librfid-send_script librfid-tool; do
  cp -a utils/${i} /tmp/TRANSFER/app-librfid.generated/config/includes.chroot/usr/local/bin/${i}-readmulti
done

cat > /tmp/TRANSFER/app-librfid.generated/add.sh <<EOF
#!/bin/bash

mkdir -p ../@config
rsync -av config/ ../@config
EOF
chmod 755 /tmp/TRANSFER/app-librfid.generated/add.sh
