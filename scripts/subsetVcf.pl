#!/usr/bin/perl
#
# usage: perl subsetVcf.pl matches.txt file.vcf

# open contig id file (intersection matches) and save contigs in a hash
$snpfile = shift(@ARGV);
open(IN, $snpfile) or die;
while(<IN>){
	chomp;
	$snps{$_} = 1;
}

close(IN);

# open vcf file
$vcfile = shift(@ARGV);
open(IN, $vcfile) or die;
open(OUT, "> sub_$vcfile") or die "couldn't write\n";
while(<IN>){
	chomp;
	# match contig IDs to those in the hash, print lines that match to new file
	if(m/^(contig_\d+)\s+(\d+)/){
		$contig = "$1_$2";
		if(defined ($snps{$contig})){
				print OUT "$_\n";
		}
	}
}	
close(IN);
close(OUT);
