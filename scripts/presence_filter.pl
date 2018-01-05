#!/usr/bin/perl

# written by Zach Gompert, Sylvia watched 

# This script parses through a msaout.fasta file with two individuals and selects ONLY the consensus seqs with both species present
# joins consensus, removed hard wrap, removes + and - characters
# NOTE: remember to read through this script and change a & e to the indicators of your choice

# usage: ./presence_filter msaout.fasta

$in = shift(@ARGV);
open(IN, $in) or die "failed to open $in\n";
open(OUT, "> contigs_$in") or die "failed to write OUT\n";
$scnt = 1;

while(<IN>){
	chomp;
	if(m/^>\*cent/){
		# change a & e to the indicators of your choice
		$cnt{'e'}=0;
		$cnt{'a'}=0;
		m/centroid=([ae])/ or die "this is weird $_\n";
		$cnt{$1}++;
	}	
	# change a & e to the indicators of your choice
	elsif(m/centroid=([ae])/){
		$cnt{$1}++;
	}
	elsif(m/^>consensus/){
		# change a & e to the indicators of your choice
		if($cnt{'a'}==1 and $cnt{'e'}==1){
			$flag = 1;
			@seq = ();
			while($flag==1){
				$seq = <IN>;
				if($seq =~ m/[ATCGN]/){
					chomp($seq);
					push(@seq,$seq);
				}
				else{
					$flag = 0;
					$seq = join("",@seq);
				}
			}
			$seq =~ s/[\+\-]+//g;
			print OUT ">contig_$scnt\n$seq\n";		
			$scnt++;
		}
	}
}
close(IN);
close(OUT);

print "finished, retained $scnt contigs\n";
