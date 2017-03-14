#! /usr/bin/python
# 
# This script filters a vcf file based on overall sequence coverage, number of
# non-reference reads, number of alleles, and reverse orientation reads.  
# See below for default values, and to change them, if necessary. Additionally,
# note that currently, the number of retained loci is being written at the end
# of the file. 
# Usage: ./vcfFilter.py <variant file>.vcf > outfile.vcf

import sys
import re
import shutil
#import tempfile

### stringency variables, edit as desired
minCoverage = 25 # minimum number of seqs; DP
minAltRds = 4 # minimum number of sequences with the alternative allele; AC
notFixed = 1.0 # removes loci fixed for alt; AF
mapQual = 15 # minimum mapping quality


n_seqs_retained = int()
with open(sys.argv[1], 'rb') as file:
    for line in file:
        if line[0] == '#':
            print line.split('\n')[0]
        else:
            dp = int(re.findall('DP=[0-9]+', line)[0].split('=')[1])
            ac = int(re.findall('AC1=[0-9]+', line)[0].split('=')[1])
            af = float(re.findall('AF1=[0.0-9.0]+', line)[0].split('=')[1])
            dp4 = re.findall('DP4=[0-9,]+', line)[0].split('=')[1]
            dp4_1, dp4_2, dp4_3, dp4_4 = map(int, dp4.split(','))
            if re.findall('MQ=NaN', line):
                continue # some of the MQ are NaN, let's just skip those (they would be filtered out anyways)
            else: 
                mq = float(re.findall('MQ=[0.0-9.0]+', line)[0].split('=')[1])
                if (dp >= minCoverage and ac >= minAltRds and af != notFixed and mq >= mapQual and dp4_2 == 0 and dp4_4 == 0):
                    print line.split('\n')[0]
                    #n_seqs_retained += 1
                else:
                    continue
    file.close()

#print '#Retained %i variable loci' % n_seqs_retained
