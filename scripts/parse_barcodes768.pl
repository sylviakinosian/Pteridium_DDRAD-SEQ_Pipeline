#!/usr/bin/perl 

## This program removes barcode sequences from fastq reads and places them
## in the name. This program also removes adpater sequences from the 3' end.
## Qual scores corresponding to the removed barcode and adapter are removed 
## as well. The reads are separted into separate files based on species and
## enzymes (for the pines). This part of the code will not be necessary in 
## most cases where each lane contains a single experiment. Sequences not
## matching any barcodes are written to a separate file (miderrors.txt).

## This now includes a function for correcting barcodes that are off by 1.

## Version 1.0, 11ii13, includes consisten dash format and always grabs four rows of sequences
#
## parse_barcodes.jan.pl barcodes_manacus1.csv rawreads_flowcell1/UW_1.fastq

use warnings;

unless (scalar @ARGV > 1){
    die "I need two arguments to run.";
}
my $barcodes = shift(@ARGV);
my $infile = shift (@ARGV);

open (INFILE, $infile) or die "Could not open the INFILE: $infile";
open (MIDS, $barcodes) or die "Could not open MID file: $barcodes";

print "$infile\n$barcodes\n";

my %mids;
my %midsctr;
<MIDS>; ## get rid of top line in MIDS file
while(<MIDS>){
    chomp;
    @line = split ',', $_;
    $line[1] =~ tr/[a-z]/[A-Z]/; ## make barcodes uppercase
    $bcode = "$line[1]"."CAATTC"; # add restriction site, not necessary if barcode + res. site is included
    #$bcode = $line[1]; ## This version assumes CAATTC is already included as part of the barcode
    $mids{$bcode} = $line[2];
    $midsctr{$bcode} = 0; ## initialize counters to zero
}
close (MIDS) or die "Could not close MIDS\n";

## make a matrix of each base in adaptor that includes mid
## (16 columns, 10 bp mid + CAATTC)
@midmat = ();
$i = 0;
foreach $m (sort keys %mids){
    $midmat[$i] = [ split '', $m ];
    $i++;
}

$infile =~ s/.*\/([\w.]+fastq)$/$1/;  ## simplify file name by
#$infile =~ s/.*\/([\w.]+fastq\.a[a-z])$/$1/;  ## simplify file name by
## dropping leading folder name
open (SEQ, "> parsed_"."$infile") or 
    die "Could not open SEQ\n";
open (CRAP, "> miderrors_"."$infile") or die "Could not open CRAP\n";

my %midcnt;

my $mseprob = 0;
my $seqcnt = 0;
my $goodmid = 0;
my $goodmidctr = 0;
my $badmidctr = 0;
my $adlen;
my $adrem = 0;
my @ad;
my $bclen = 16; # 10 bc and 6 res. site
my $qline;
my $tooshort = 0;

while (<INFILE>){
    chomp;
    ## new sequence starts here
    $seqcnt++;
    if(!($seqcnt % 10000)){
	print "$seqcnt\n";
    }
    $_ = <INFILE>;
    chomp($_);
    if (s/(TTACAGATCGGAAGAG.*)//){ 
##          CTTACAGATCGGAAGAGCTCGTATGCCGTCTTCTGCTTG
	## potentially has Illpcr seq at end, so we lop this off
	## 
	@ad = split "", $1;
	$adlen = @ad;
	$mseprob++;
    }
    else {
	$adlen = 0;
    }
    $line10 = substr($_, 0, $bclen); ## substr EXPR,OFFSET,LENGTH
    $line9 = substr($_, 0, ($bclen - 1)); # 9 bp barcode
    $line8 = substr($_, 0, ($bclen - 2)); # 8 bp barcode
    if($mids{$line10}){ ## this is a barcode, which I have now pulled off
	s/^$line10//;
	if (/[ATCGN]/) { ## didn't remove it all, there is seq in $_
	    print SEQ "@"."$mids{$line10}"." -- "."$seqcnt\n";
	    print SEQ "$_\n";
	    $goodmid = 1;
	    $goodmidctr++;
	    $midsctr{$line10}++;
	}
	$whichL = 10;
    }
    
    elsif($mids{$line9}){ ## this is a barcode, which I have now pulled off
	s/^$line9//;
	if (/[ATCGN]/) { ## didn't remove it all, there is seq in $_
	    print SEQ "@"."$mids{$line9}"." -- "."$seqcnt\n";
	    print SEQ "$_\n";
	    $goodmid = 1;
	    $goodmidctr++;
	    $midsctr{$line9}++;
	}
	$whichL = 9;
    }
    
    elsif($mids{$line8}){ ## this is a barcode, which I have now pulled off
	s/^$line8//;
	if (/[ATCGN]/) { ## didn't remove it all, there is seq in $_
	    print SEQ "@"."$mids{$line8}"." -- "."$seqcnt\n";
	    print SEQ "$_\n";
	    $goodmid = 1;
	    $goodmidctr++;
	    $midsctr{$line8}++;
	}
	$whichL = 8;
    }
    
    elsif(length $line10 != $bclen){
	$goodmid = 0;  ## this is a special case, where don't have
	## enough remainging sequence to even test
	## for a mid
	$tooshort++;
    }

    else { ## potential mid error
	($line10b, $n10) = correctmid($line10);
	$minN = $n10;
	$whichL = 10;
	if ($minN > 1){
	    ($line9b, $n9) = correctmid($line9);
	    if ($n9 < $minN){
		$minN = $n9;
		$whichL = 9;
	    }
	    if ($minN > 1){
		($line8b, $n8) = correctmid($line8);
		if ($n8 < $minN){
		    $minN = $n8;
		    $whichL = 8;
		}
	    }
	}
	if ($minN > 1){ ## can't correct
	    print CRAP "$_\n";
	    $goodmid = 0;
	    $badmidctr++;
	}
	else { ## has been corrected
	    if ($whichL == 10){
		$line = $line10b;
		s/$line10//;
	    }
	    elsif ($whichL == 9){
		$line = $line9b;
		s/$line9//;
	    }
	    elsif ($whichL == 8){
		$line = $line8b;
		s/$line8//;
	    }
	    if (/[ATCGN]/) { ## didn't remove it all
		print SEQ "@"."$mids{$line}"." -- "."$seqcnt\n";
		print SEQ "$_\n";
		$goodmid = 1;
		$goodmidctr++;
		$midsctr{$line}++;

	    }
	    else {
		$goodmid = 0;
	    }
	}
    }

    $_ = <INFILE>;
    chomp($_);
    if (/^\+/ && $goodmid == 1){ 
	print SEQ "$_\n";
    }
    $_ = <INFILE>;
    chomp($_);
    if ($goodmid == 1){ ## qual score, needs to be trimmed
	if ($whichL == 10){
	    $seqlength = (length $_) - $bclen - $adlen;
	    $qline = substr($_, $bclen, $seqlength);
	}
	elsif ($whichL == 9){
	    $seqlength = (length $_) - $bclen - $adlen + 1;
	    $qline = substr($_, ($bclen - 1), $seqlength);
	}
	elsif ($whichL == 8){
	    $seqlength = (length $_) - $bclen - $adlen + 2;
	    $qline = substr($_, ($bclen - 2), $seqlength);
	}
	print SEQ "$qline\n";
	$goodmid = 0;
    }
}
foreach my $k (sort keys %midsctr){
    print "$k,$midsctr{$k}\n";
}

print "Good mids count: $goodmidctr\n";
print "Bad mids count: $badmidctr\n";
print "Number of seqs with potential MSE adapter in seq: $mseprob\n";
print "Seqs that were too short after removing MSE and beyond: $tooshort\n";

close (SEQ) or die "Could not close SEQ\n";
close (CRAP) or die "Could not close CRAP\n";

##--------- sub routines -----------------##

sub correctmid{
    my @seq = split //, $_[0];
    my @dist = ();
    my $corrected;
    my $bc = length($_[0]) - 1; # 1 less than barcode length
    ## initialize distance vector
    for my $i (0 .. $#midmat){
	$dist[$i] = 0;
    }

    ## calc distances
    foreach my $m (0..$#midmat){
	foreach my $i (0..$bc){
	    if (defined($midmat[$m][$i])){
		unless($seq[$i] eq $midmat[$m][$i]){
		    $dist[$m] = $dist[$m] + 1;
		}
	    }
	    else {
		$dist[$m] = $dist[$m] + 9; # can't be it, wrong length
	    }		
	}
    }

    ## which min
    my $min = 100;
    my $mindex = -1;
    foreach my $m (0 .. $#dist){
	if($min > $dist[$m]){
	    $min = $dist[$m];
	    $mindex = $m;
	}
    }
    $corrected = join '',  @{$midmat[$mindex]} ;
    return($corrected, $min);
}
