nfc-live is a set of scripts to create a bootable system stuffed with
many RFID & NFC-related opensource softwares.

The project doesn't contain any of those softwares but scripts to download them.
Occasionally it may contain patches if it was not yet possible to fix
the upstream versions.

It relies on the Debian Live project and live-boot:
http://live.debian.net
http://live.debian.net/manual/3.x/html/live-manual.en.html

STRUCTURE:
==========
content_for_iso/
          => contains one directory per project/item:
  000-*       => essential elements
  app-*       => applications
  doc-*       => documentations
  driver-*    => drivers
  @config/    => will contain the chosen config
Each of those subdirectories contains (some of) the following scripts:
     add.sh       => to add the corresponding item to the to-be-generated ISO
(opt)prepare.sh   => occasionally a first step has to be performed
                     before running add.sh to download required pieces
(opt)clean.sh     => to clean data fetched by prepare.sh
(opt)live-*.sh    => will be used in live system to generate binaries
Some subdirectories are special:
  *.devel     => they don't install directly the software but a script to be
                 run from the ISO to download and compile the software 
                 from sources, see below for details
  *.generated => they are produced by the scripts contained in *.devel and
                 contain binaries
live/
          => will contain the generated ISO and all temp files, including cache
build-iso
          => create fresh live-boot config, import config items
             created by add.sh and build iso
build-clean
          => clean live-boot config, bootstrap cache, but keeps cached debs
             you've to delete live/cache manually if you want to remove them
run_kvm
          => run generated ISO in qemu-kvm
run_vbox
          => run generated ISO in VirtualBox
             You've first to create an empty VB config and link the ISO to it
             then update the UUID in run_vbox script

USAGE:
======
First time:
-----------
Choose which elements you want to add to the ISO.
Most of them are independent but some are dependent, especially
app-misc and app-libnfc are almost mandatory
* content_for_iso/*/prepare.sh to fetch data
* content_for_iso/*/add.sh to add item to ISO generation configuration
* build-iso
Result is live/binary.hybrid.iso
To use it, see:
http://live.debian.net/manual/3.x/html/live-manual.en.html#180
The first time you couldn't add any *.generated items as you had only *.devel
So if you added a *.devel you'll find in the generated ISO some scripts:
/root/live-*.sh
Execute them in the live system (e.g. within VirtualBox), it will create
new *.generated config subdirectories in /tmp/TRANSFER/
Because some need libnfc, execute first live-libnfc.sh if the generated package
is not yet installed. live-libnfc.sh will install libnfc after compilation
To avoid problems in the transfer, make a tar.gz out of /tmp/TRANSFER/
Copy it out of the ISO, e.g. in VirtualBox you can use ssh/scp/sshfs
to 10.0.2.2, the IP of the host

Second time:
------------
Now you have additional content_for_iso/*.generated subdirectories.
* content_for_iso/*.generated/add.sh
If you prefer to create an ISO with only the binaries and not the devel parts
anymore, delete content_for_iso/@config and run all the desired add.sh scripts
* build-iso

Next times:
-----------
* To change the config, delete content_for_iso/@config
  and run the required content_for_iso/*/add.sh
* build-iso

Updates:
--------
* Update prepare.sh and live-*.sh scripts
  to fetch a more recent revision if needed
* content_for_iso/*/clean.sh to remove fetched data
* content_for_iso/*/prepare.sh to fetch data again
For *.devel, just execute again the live-*.sh in live system
to create a new *.generated config

Exceptions and special cases:
-----------------------------
* content_for_iso/app-proxmark3fw
  Proxmark firmwares require a toolchain
  See content_for_iso/app-proxmark3fw/howto.txt
