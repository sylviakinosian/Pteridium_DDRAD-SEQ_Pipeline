#! /bin/bash
# written by Martin Schilling
# this script converts sam files to bam files

for i in *.sam; do
    #file=$(echo $i | cut -f7 -d/)
	ids=$(echo $i | cut -f1 -d.)   # keep the path in id  (for output)
    #id=$(echo $id | cut -f7 -d/)
    #RG=\'@RG'\t'ID:${id}\'
    echo $ids

    # edit the path to samtools
    ~/hts_tools/samtools-1.3.1/samtools view -S -u $i -o ${ids}.bam

done


