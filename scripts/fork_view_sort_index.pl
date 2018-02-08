#!/usr/bin/perl
#
# example script demonstrating ForkManager
# the first argument is the number of processors to use
# this is followed by all of the files to iterate over
# the script writes just the header of the sam file to a new file
#
# to run this on all of the sam files in a directory with 20 cores you would use
#
# perl ./forkExample.pl 20 ./*.sam
#

use warnings;
use strict;
use Parallel::ForkManager;

my $max = shift(@ARGV); ## get number of cores to use at one time

my $pm = Parallel::ForkManager->new($max);

FILES:
foreach my $file (@ARGV){ ## loop through set of fastq files
	$pm->start and next FILES; ## fork
	my $base = $file;
	$base =~ s/sam// or die "failed to remove sam name\n";
	$base =~ s!.*/!! or die "failed to remove path\n";
	system "samtools view -o $base"."bam $file\n";
	system "samtools sort -o $base"."sorted.bam $base"."bam\n";
	system "samtools index -b $base"."sorted.bam\n";

	$pm->finish; ## exit the child process
}

$pm->wait_all_children;

