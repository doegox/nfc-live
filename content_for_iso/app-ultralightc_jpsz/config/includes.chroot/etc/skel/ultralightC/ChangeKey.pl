#!/usr/bin/perl
require "ultralightC.pl";

Init();
ScanUltraC();
Authenticate("T");
# Pour changer la clef vers "000102030405060708090A0B0C0D0E0F" 
Write("2C","07:06:05:04");
Write("2D","03:02:01:00");
Write("2E","0F:0E:0D:0C");
Write("2F","0B:0A:09:08");
CloseReader();