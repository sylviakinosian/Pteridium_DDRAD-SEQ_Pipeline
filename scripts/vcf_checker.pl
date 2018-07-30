#!/usr/bin/perl

# this scipt parses through a .vcf file and finds the intersection of all snps 
# usage: ./vcf_checker.pl bigger.vcf smaller(toMatch).vcf

use strict;
use warnings;

use lib '.';
use lib "$ENV{~/apps/Array-Utils-0.5/temp/x86_64-linux-thread-multi/}";
use Array::Utils qw(:all); 

my $first = shift(@ARGV);
my $second = shift(@ARGV);
open(ONE, $first) or die "failed to open $first\n";

my @cntgs = ();
my @m_cntgs = ();
my $out = 'matches.vcf';
open (my $o, '>', $out) or die "could not write outfile\n";

while(<ONE>){
	chomp;
	if(m/^contig_[0-9]+/){
		my @fields = split/\t/;
		my $new = "@fields[0]"."_@fields[1]";
		push(@cntgs, $new);
		#print @cntgs;
	}    
        else{
        	next;
    	}    
}
close (ONE);
open(TWO, $second) or die "failed to open $second\n";

while(<TWO>){
	chomp;
	if(m/^contig_[0-9]+/){
		my @fields = split/\t/;
		my $new = "@fields[0]"."_@fields[1]";
		push(@m_cntgs, $new);
	}
	else{
		next;
	}
}
close(TWO);

my @matches = intersect(@cntgs, @m_cntgs);
my $cnt = scalar(@matches);
my $line;

for my $line(@matches){
	print $o "$line\n";
}

close $o;
print "number of contigs in both files: $cnt\n";
