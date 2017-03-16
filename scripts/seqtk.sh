#! /bin/bash
# written by Martin Schilling
# this script converts .fastq files to .fasta files

for i in *.fastq; do
    id=$(echo $i | cut -f1 -d.)
    echo $id
	seqtk seq -a $i > $id.fasta
	done

