#!/usr/bin/perl
require "ultralightC.pl";

Init();
ScanUltraC();
# T = 49454D4B41455242 214E4143554F5946
#Authenticate("000102030405060708090A0B0C0D0E0F");
Authenticate("T");
CloseReader();
