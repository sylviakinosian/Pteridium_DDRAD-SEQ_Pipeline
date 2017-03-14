#! /bin/bash
#

for i in *.sorted.bam; do
    ids=$(echo $i | cut -f1 -d.) #keep the path in ids (for output)
    echo $ids
    ~/hts_tools/samtools-1.3.1/samtools flagstat $i # > pterFlagstat

done
