#!/usr/bin/perl
#
# written by Zach Gompert and Sylvia Kinosian
#
# This script uses a list of the contigs found in two VCF files to subset the first file, and then find the matching contig in the second file, and append the genetic data from that to the contig from first file.

# usage: perl combine.pl 2ae.vcf 4ae.vcf

use warnings;
use strict;

# open the two VCF files for parsing
my $vcf2 = shift(@ARGV);
my $vcf4 = shift(@ARGV);
open(DIP, $vcf2) or die "could not open diploid file\n";
open(OUT, "> aeAll.vcf") or die "could not write OUT\n";

my $line;
my $id;

while(<DIP>){
	chomp;
	if (m/^(contig_\d+\s+\d+)/){
		# save the whole line as $line; $1 is the contig info
		$line = $_;
		$id = $1;
		# open the tetraploid file
		open(TET, $vcf4) or die "could not open tetraploid file\n";
		while(<TET>){ 
			chomp;
			# match contig from DIP to corresponding one in TET
			if (m/^$id/){
				# pull off the individual info at the end of the line
				my @data = split(m/:PL/, $_);
				# print line from DIP + ind. info from TET to new file
				print OUT "$line"."@data[1]\n";
				}
		}
	}
}

close(DIP);
close(TET);
close(OUT);
