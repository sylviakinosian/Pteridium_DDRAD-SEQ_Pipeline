#! /bin/bash
# written by Martin Schilling
# this script indexes all .sorted.bam files before calling variants

for i in *.sorted.bam; do
    #file=$(echo $i | cut -f7 -d/)
    ids=$(echo $i | cut -f1 -d.)
    #id=$(echo $id | cut -f7 -d/)
    #RG=\'@RG'\t'ID:${id}\'
    echo $ids

    # edit the path to samtools
    ~/hts_tools/samtools-1.3.1/samtools index $i 

done


