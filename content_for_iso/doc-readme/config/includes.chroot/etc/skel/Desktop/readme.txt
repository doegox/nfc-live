* Non-US keyboard?
==================
  menu -> settings -> keyboard -> layout 
  -> choose "be" for Belgian or add another one

* Software list
===============
Omnikey Cardman driver     2.10.0.1
SCL3711 driver             2.11
pcscd                      1.8.4-1
pcsc-tools                 1.4.20-1
libccid                    1.4.7-1
smartcard_list.txt         2013-01-20 r6510
opensc                     0.12.2-3
python-pyscard             1.6.12.1-3
RFIDIOt                    2013-01-14 (git 88ec1f6e on repo doegox)
cardpeek                   0.7.1 (svn r208)
epassportviewer            2.0.14 + patches
libnfc                     1.7.0-rc2
nfcutils                   2013-01-16
libfreeware                2013-01-16 + patch
rfdump                     1.6-2
librfid                    r2107 + patches
proxmark3                  2013-01-16 (svn r649)
+ firmwares & traces in /usr/local/share/proxmark3/
sniff-pn53x.sh             2011-06-05
ultralightC.pl JPSZ        2009-10
MOBIB-Extractor            1.0.6 + patches

Development tools and dependencies are installed so you can easily
fetch the latest versions and compile them.

Are also installed:
openssh, sshfs, rsync, openssl, cu, mc, evince, screen, leafpad, iceweasel,
socat, vbindiff, bsdiff, and all basic stuffs: hexedit, od, xxd, ...

* Supported readers and software
================================

** via PCSC daemon directly:
----------------------------

  Tested          | PCSC  RFIDIOt cpk ePV ulc |
  Readers         | tools                     |
------------------+---------------------------+
- ACR122U-PICC    | v#1   v#1,4   v#1 x#1     |
- Touchatag       | v     v#4     v#2 v   v   |
- SCL3711 proprio | v#7           v#7 v#7     |
- SCL3711 ifdnfc  | v#8   v#8         v#8     |
- Omnikey 5321    | v#3   v#4b    v#5 v       |
- contact rdrs    | v             v           |
- PN533           | v#6   v#4,6   v#6 v#6     |
- ASK LoGO        | v#6   v#4,6   v#6 v#6     |
------------------+---------------------------+
#1  unstable, reader disconnects regularly
#2  by default it sees the internal SAM slot
#3  for scriptor, use option: -r “OMNIKEY CardMan 5x21 00 01”
#4  use option: -R READER_PCSC
#4b use option: -R READER_PCSC -r1
#5  select second reader to get the RFID interface
#6  using libnfc via ifdnfc experimental driver,
    only support for ISO14443A-4
#7  execute "scl3711-pcsc_proprio" first
#8  execute "scl3711-pcsc_ifdnfc" first

** via libnfc + PCSC daemon:
----------------------------

  Tested          | libnfc RFIDIOt lsnfc libff |
  Readers         | tools                      |
------------------+----------------------------+
- ACR122U-PICC    | v#1    #1,2    v#1   v#1   |
- Touchatag       | v      #2      v     v     |
- SCL3711         | only without pcsc see below|
------------------+----------------------------+
#1  unstable, reader disconnects regularly
#2  buggy, use option: -f 0

** via libnfc (without PCSC):
-----------------------------

  Tested          | libnfc RFIDIOt lsnfc libff mobib |
  Readers         | tools                            |
------------------+----------------------------------+
- PN531           | v#1    v       v     v           |
- PN533           | v      v       v     v     v#3   |
- SCL3711         | v#2    v#2     v#2   v#2   v#3   |
- ASK LoGO        | v      v       v     v     v     |
------------------+----------------------------------+
#1  partial working: not in raw modes, e.g. nfc-anticol
#2  execute "scl3711-libnfc" first
#3  Mobib Basic ok, for regular one use LoGO

** standalone (without PCSC):
-----------------------------

  Tested          | librfid RFIDIOt serial rfdump |
  Readers         |                               |
------------------+-------------------------------+
- Omnikey 5321    | v#1                           |
- ACG LF          |          v#2    v#3    v#4    |
- Frosch          |          v#5                  |
- openpicc        |                 v#6           |
------------------+-------------------------------+
#1  need to stop pcscd first
#2  use option: -R READER_ACG -s 57600
    baudrate may differ
#3  use e.g. command: screen /dev/ttyUSB0 57600
    "ctrl-a k" to quit screen
    baudrate may differ
#4  may need to change baudrate
#5  use option: -R READER_FROSCH
#6  use e.g. command: screen /dev/ttyACM0 115200
    "ctrl-a k" to quit screen


* Documentation
===============
see folder "nfc-doc" on Desktop
- PCSC specs
- readers functional datasheets
- tools documentations
- mifare specs
- and more...
nfc-doc is also directly accessible without booting the ISO

