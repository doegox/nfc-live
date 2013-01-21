#!/usr/bin/perl
require "ultralightC.pl";

Init();
ScanUltraC();
#Authenticate("000102030405060708090A0B0C0D0E0F");
Authenticate("T");
dumpUltraC();
CloseReader();

