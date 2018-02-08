#! /bin/bash

# written by Sylvia Kinosian
# this script parses through the current directoy and aligns all .fastq files to a reference (REF)
# BWA ALN is the alignment algorith and SAMSE converts the .sai files from ALN to .sam files

# change this path to your reference genome or pseudo-reference created in the first part of the Pteridium_GBS_Pipeline cheat sheet
REF='/uufs/chpc.utah.edu/common/home/wolf-group2/skinosian/3pteridium/parse/fastq/ae_consensus_final.fasta'

for i in *.fastq;
do
ids=$(echo $i | cut -f1 -d.)
echo $ids

/uufs/chpc.utah.edu/common/home/u6009816/apps/bwa-0.7.15/bwa aln -n 4 -l 20 -k 2 -t 8 -q 10 -f $ids.sai $REF $i

/uufs/chpc.utah.edu/common/home/u6009816/apps/bwa-0.7.15/bwa samse -n 1 -r "@RG\tID:$ids\tLB:$ids\tSM:$ids\tPL:ILLUMINA" -f $ids.sam $REF $ids.sai $i

done
