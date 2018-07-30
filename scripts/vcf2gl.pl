#!/usr/bin/perl
#
# This scripts conversts a vcf file to a simpler format for downstream analysis. I am calling this format genetoype likelihood (gl). The first line lists: the number of individuals and loci. The next line has individual ids. This if followed by on line per SNP that gives the SNP id (scaffold, position) and the phred-scaled genotype likelihoods, three per individual. The script prints the non-reference allele frequency to a file so that they can be used to estimate genotypes
#
# USAGE: perl vcf2gl.pl myfile.vcf
#

my $in = shift(@ARGV);
my @line = ();
my $word;
my $nind = 0;
my $nloc = 0;
my $out = $in;
$out =~ s/vcf/gl/ or die "failed file name sub\n";

open (OUT, "> $out") or die "Could not write the outfile\n";

if ($out =~ s/gl/txt/){
	open (OUT2, "> af_$out") or die "Count not write the alt. af file\n";
}

open (IN, $in) or die "Could not read the vcf file\n";
while (<IN>){
	chomp;
	## get individual ids
	if (m/^#CHROM/){
		@line = split(m/\s+/, $_);	
		foreach $word (@line){
			if ($word =~ m/[0-9a-zA-Z_]*/){ ## this is an individual id
				push (@inds, $word);
				$nind++;
			}
		}
		## NOTE, number of loci is not correct, need to add manually after the fact
		## somdeday I will fix this
		print OUT "$nind $nloc\n";
		$word = join (" ", @inds);
		print OUT "$word\n";
	}
	## read genetic data lines, write gl
	elsif (m/^contig_(\d+)\s+(\d+)/){# modify this regular expression as needed
			$word = "$1".":"."$2";
			if (m/AC=(\d+)/){
				$p = $1;
				$p = $p/($nind*2.0);
				#print "$word = $p\n";
				$nloc++;
				print OUT "$word ";
				@line = split(m/\s+/, $_);
				$i = 0;
				foreach $word (@line){
					if ($word =~ s/^\d\/\d\://){
						$word =~ s/\d+,\d+:\d+:\d+:// or die "failed sub $word \n";
						$word =~ s/,/ /g;
						print OUT " $word";
					}
					elsif ($word =~ m/\.\/\./){
						print OUT " 0 0 0";
					}
			
				}
				print OUT "\n";
				print OUT2 "$p\n"; ## print p before converting to maf
			}
		}
	}	

close (OUT);
close (OUT2);
print "Number of loci: $nloc; number of individuals $nind\n";
