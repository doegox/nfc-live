#!/usr/bin/perl
# Jean-Pierre Szikora <jean-pierre.szikora@uclouvain.be>
# decembre 2009
use Chipcard::PCSC;
use Chipcard::PCSC::Card;
use Crypt::DES;
use Crypt::DES_EDE3;
use Crypt::CBC;

$debug = 1;

my %options;
my $hContext = new Chipcard::PCSC();
my $hCard;
die ("Could not create Chipcard::PCSC object: $Chipcard::PCSC::errno\n") unless defined $hContext;

$options{p} = $Chipcard::PCSC::SCARD_PROTOCOL_T0 | $Chipcard::PCSC::SCARD_PROTOCOL_T1;

#my @readers_list = $hContext->ListReaders ();
#die ("Can't get readers list\n") unless defined $readers_list[1];
#print STDERR "No reader given: using $readers_list[1]\n";
$options{r} = "ACS ACR 38U-CCID 00 00";

$hCard = new Chipcard::PCSC::Card ($hContext, $options{r}, $Chipcard::PCSC::SCARD_SHARE_EXCLUSIVE, $options{p});
die ("Can't allocate Chipcard::PCSC::Card object: $Chipcard::PCSC::errno\n") unless defined $hCard;

sub apdu {
        $_ = $_[0];
        s/:/ /g;
        $SendData = Chipcard::PCSC::ascii_to_array($_);
        $RecvData = $hCard->Transmit($SendData);
        die ("Can't get info: $Chipcard::PCSC::errno\n") unless defined $RecvData;

        $res = Chipcard::PCSC::array_to_ascii($RecvData);
        $_ = $res;
        s/ /:/g;
        return $_;
        }

sub GetResult   {
        $length = $_[0];
        $GetResult_APDU = "FF:C0:00:00:" . $length;
        return &apdu ($GetResult_APDU);
        }

sub Init {
        $AntennaPowerOff = "FF:00:00:00:04:D4:32:01:00";
        $AntennaPowerOn = "FF:00:00:00:04:D4:32:01:01";
        $SetRetryTimer = "FF:00:00:00:06:D4:32:05:00:00:00";
        &apdu ($AntennaPowerOff);
        &apdu ($AntennaPowerOn);
        $out = &apdu ($SetRetryTimer);
        if (!($out =~ s/61:(..)/$1/))   {
                print "Error in SetRetryTimer\n";
                }
        #print "SetRetryTimer: $out\n";
        #$result = &GetResult($out);
        #print "Result: $result\n";
        }

sub ScanUltraC	{
        $out = &apdu ($SetRetryTimer);
        $Polling = "FF:00:00:00:04:D4:4A:01:00"; # InListPassiveTarget avec MaxTg = 1
        $out = &apdu ($Polling);
        $out =~ s/61:(..)/$1/;
        if ($out == "05")       {
                print "No Card on the Reader\n";
                &CloseReader;
                exit ;
                }
        else    {
                $result = &GetResult ($out);
		$result =~ s/:90:00$//;
        $result =~ /D5:4B:01:01:(..:..):(..):07:(..:..:..:..:..:..:..)/;

		$sens_res = $1;
		$sel_res = $2;
		$uid = $3;
		if ($debug >= 1)	{
			print "UID: $uid   ATQA:$sens_res   SAK:$sel_res\n";
			}
        return $uid;
                }
        }
sub ReadSector {
	$bloc = $_[0];
	$sector = $_[1];

	if ($bloc > 31)	{
		$sect = ($bloc - 32) * 16 + $sector + 128;
		}
	else	{
		$sect = $bloc * 4 + $sector;
		}
	$sect_hex = sprintf ("%02x", $sect);
	# 30: Read 16 bytes a partir de l'adresse donnée
	# dans une commande inDataExchange
	$Read = "FF:00:00:00:05:D4:40:01:30:" . $sect_hex;
	$out = &apdu ($Read);
	$out =~ s/61:(..)/$1/;
	if ($out ne "15")	{
		print "No data returned from read\n";
		return "";
		}
	$result = &GetResult ($out);
	$result =~ s/D5:41:00:(.*):90:00/$1/;
	return $result;
	}
        
sub dumpUltraC	{
	$i=0;
                for ($j = 0; $j <= 10 ; $j++)    {
                        $data = &ReadSector ($j,$i);
                        if ($data ne "")        {
                        		$result = $data;
			    				$result =~ s/://ges;
        						$result =~ s/../pack("H2",$&)/ges ;
								$result =~ tr/\040-\176\241-\376/./c;
								$adresse = $j * 4;
								$adresse_hex = sprintf ("0x%02x", $adresse);
                                print "Address: $adresse_hex\t$data\t$result\n";
                        }
                }

	}
sub Write {
        $bloc = $_[0];
		$data = $_[1];

		# A2: Write 4 bytes a partir de l'adresse donnée
		# dans une commande inDataExchange
		$Write = "FF:00:00:00:09:D4:40:01:A2:" . $bloc . ":" . $data;
		$out = &apdu ($Write);
        $out =~ s/61:(..)/$1/;
        $result = &GetResult ($out);
        $result =~ s/D5:41:(..):90:00/$1/;
        if ($result ne "00")    {
                print "Bad Write on bloc $bloc ($data)\n";
                return (0);
                }
        else {
                return (1);
                }
        }
 
sub Authenticate {
	my $debug2 = 0;
	$key = $_[0];
	# UltraLightC Transport key
	$transport_key = "49454D4B41455242214E4143554F5946"; # IEMKAERB!NACUOYF in ascii
	if ($key eq "T")	{
		$key = $transport_key;
		}
	# Preparation de la clef (2 key 3DES encryption)
	$key_first_half = $key_second_half = $key;
	$key_first_half =~ s/(................)................/$1/;
	$key_second_half =~ s/................(................)/$1/;
	$key = $key_first_half . $key_second_half . $key_first_half;
	# convertion HEX --> BIN sur place
	$key =~ s/../pack("H2",$&)/ges ;
	# RndA : 8 bytes
	$RndA = "";
	for ($i = 1 ; $i <= 8 ; $i++)	{
		$RndA = $RndA . sprintf ("%02x", int(rand(256)));
		}
	# APDU Authenticate "1A" dans une commande InCommunicateThru
	$Auth1_apdu = "FF:00:00:00:04:D4:42:1A:00";
	if ($debug2)	{
		print "Key: $key_first_half $key_second_half\n";
		print "Auth1_apdu: $Auth1_apdu\n";
		}
	# taille de la reponse
	$out = &apdu ($Auth1_apdu);
    $out =~ s/61:(..)/$1/;
    # reponse
    $Resp1 = &GetResult ($out);
	if ($debug2)    {
                print "Auth1_resp: $Resp1\n";
                }
    # nettoyage pour recuperer les 8 bytes de ek(RndB)
    $Resp1 =~ s/:90:00$//;
	$Resp1 =~ s/^D5:43:00:AF://;
	$Resp1 =~ s/://g;
	$Resp1 =~ s/../pack("H2",$&)/ges ;
	# Dechiffre avec IV=0x0 pour obtenir RndB
	$cipher = new Crypt::DES_EDE3 $key;
	$RndB = $cipher->decrypt($Resp1);
	# convertion BIN --> HEX sur place
	$RndB =~ s/./unpack("H2",$&)/ges ;
	if ($debug2) {print "RndA: $RndA\n";}	
	if ($debug2) {print "RndB: $RndB\n";}
	# RndB_p obtenu par rotation a gauche de 8 bits
	$RndB_p = $RndB;
	$RndB_p =~ s/(..)(..............)/$2$1/;
	$concat = $RndA . $RndB_p;
	if ($debug2)    {
                print "RndA||RndB\': $concat\n";
                }
    # conversion en BIN pour le chiffrement
	$concat =~ s/../pack("H2",$&)/ges ;
	# For the subsequent encryptions the IV consists of the last ciphertext block received
	$iv = $Resp1;
	# chiffrement de RndA||RndB_p 3DES_CBC avec IV=1er echange chiffré
	$cryptobj = Crypt::CBC->new (
	    -key         => $key,
    	-padding     => "rijndael_compat",
    	-header      => "none",
    	-literal_key => 1,
    	-iv          => $iv,
    	-cipher      => "Crypt::DES_EDE3"
  	);

	$Econcat = $cryptobj->encrypt($concat);
	# Conversion en HEX
	$Econcat =~ s/./unpack("H2",$&)/ges ;
	# IV2: les 8 derniers bytes echangés
	$iv2 = $Econcat;
	$iv2 =~ s/................(................)/$1/;
	$iv2 =~ s/../pack("H2",$&)/ges ;
	# Preparation de la reponse "AF" contenant RndA||RndB_p chiffré dans une commande InCommunicateThru
	$Econcat =~ s/(..)/$1:/g;
	$Auth2_apdu = "FF:00:00:00:13:D4:42:AF:" . $Econcat;
	$Auth2_apdu =~ s/:$//;
	if ($debug2)	{
		print "Auth2_apdu: $Auth2_apdu\n";
		}
	$out = &apdu ($Auth2_apdu);
	# taille du retour
	$out =~ s/61:(..)/$1/;
	$result = &GetResult ($out);
	if ($debug2)	{
		print "Auth2_apdu: $result\n";
		}
	if ( $result eq "D5:43:02:90:00")	{ # CRC error dans la reponse a la commande InCommunicateThru
		print "Authentication: Failed\n";
		&CloseReader();
		exit;
		}
	# nettoyage pour recuperer les 8 bytes de ek(RndA')
	$result =~ s/:90:00$//;
	$result =~ s/^D5:43:00:00://;
	$result =~ s/://g;
	if ($debug2)	{
		print "E(RndA\'): $result\n";
		}	
	$result =~ s/../pack("H2",$&)/ges ;
	# dechiffrement de ek(RndA')
	$cryptobj = Crypt::CBC->new (
	    -key         => $key,
    	-padding     => "rijndael_compat",
    	-header      => "none",
    	-literal_key => 1,
    	-iv          => $iv2,
    	-cipher      => "Crypt::DES_EDE3"
  	);

	$RRndA = $cryptobj->decrypt($result);
	$RRndA =~ s/./unpack("H2",$&)/ges ;
	if ($debug2)	{
		print "RRndA\': $RRndA\n";
		}
	# rotation de 8 bits a droite pour pouvoir comparer avec RndA
	$RRndA =~ s/(..............)(..)/$2$1/;
	if ($RRndA eq $RndA)	{
		print "Authentication: OK\n";
		}
	else	{ # l'authentication failed est detecte + tot
		print "RndA NEQ Returned RndA!\n";
		}
	}

sub CloseReader	{
	&apdu ($AntennaPowerOff);
	$hCard->Disconnect($Chipcard::PCSC::SCARD_LEAVE_CARD);
	$hCard = undef;
	$hContext = undef;
	}	

