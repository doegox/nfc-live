#!/usr/bin/perl
require "ultralightC.pl";

Init();
ScanUltraC();
Authenticate("T");
Write("04","49:45:4D:4B");
Write("05","41:45:52:42");
Write("06","21:4E:41:43");
Write("07","55:4F:59:46");
Write("08","00:00:00:00");
Write("09","00:00:00:00");
Write("0A","00:00:00:00");
Write("0B","00:00:00:00");

CloseReader();