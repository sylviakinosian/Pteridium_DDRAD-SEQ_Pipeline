#! /usr/bin/python
#
# This script reads a fasta file (the last vsearch run with --id 0.8 # to test for whether clusters collapse at a lower id) and removes
# all entries that have(the 2nd) seqs > 1.
#
# Usage: ./remove_collapsed_clusters.py <input-file_name.fasta> <new_file_name.fasta>


import sys
import re
#import shutil
#import tempfile

newfile = open(sys.argv[2], 'a')
n_clusters = int()
with open(sys.argv[1], 'rb') as file:
        for i, line in enumerate(file):
           if line[0] == ">":
               cluster = re.findall(';;seqs=[0-9]+', line)[0]
               seq_n = int(re.findall('[0-9]+', cluster)[0])
               # newline = str(cluster + ',' + seq_n + '\n')
               #newfile.write(newline)
               if seq_n != 1:
                   continue
               else:
                   n_clusters += 1
                   newfile.write(line)
           else:
               if seq_n == 1:
                   newfile.write(line)
               else:
                   continue
        print n_clusters, "uncollapsed clusters found"
	file.close()
        newfile.close()


