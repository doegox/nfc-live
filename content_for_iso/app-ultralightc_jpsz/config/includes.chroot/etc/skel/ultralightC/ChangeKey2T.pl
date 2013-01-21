#!/usr/bin/perl
require "ultralightC.pl";

Init();
ScanUltraC();
Authenticate("000102030405060708090A0B0C0D0E0F");
# Pour changer vers la clef de transport "49454D4B41455242 214E4143554F5946" 
Write("2C","42:52:45:41");
Write("2D","4B:4D:45:49");
Write("2E","46:59:4F:55");
Write("2F","43:41:4E:21");
CloseReader();