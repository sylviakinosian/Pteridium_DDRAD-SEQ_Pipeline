#! /usr/bin/python
# written by Martin Schilling
# 
# This script filters a vcf file for the DP4 values
#
# Usage: ./vcfFilter.py <variant file>.vcf > outfile.vcf

import sys
import re
#import shutil
#import tempfile

n_seqs_retained = int()
with open(sys.argv[1], 'rb') as file:
    for line in file:
        if line[0] == '#':
            continue
        else:
            dp4 = re.findall('DP4=[0-9,]+', line)[0].split('=')[1]
	    var1, var2, var3, var4 = map(int, dp4.split(','))
            if var2 == 0 and var4 == 0:
	        continue
	    else:
	        print var1, var2, var3, var4

    file.close()

