#! /usr/bin/python
#
# This script reads a fasta file (after removing the collapsed clusters of id 0.8) and removes all sequences that are under a given threshold number of
# clusters (n_seq_thr).


#
# Usage: ./remove_clusters_threshold.py <n_seq_thr> <input-file_name.fasta> <new_file_name.fasta>


import sys
import re
#import shutil
#import tempfile

n_seq_thr = float(sys.argv[1])

newfile = open(sys.argv[3], 'a')
n_clusters = int()
with open(sys.argv[2], 'rb') as file:
        for i, line in enumerate(file):
           if line[0] == ">":
               cluster = re.findall(';seqs=[0-9]+;;', line)[0]
               seq_n = int(re.findall('[0-9]+', cluster)[0])
               # newline = str(cluster + ',' + seq_n + '\n')
               #newfile.write(newline)
               if seq_n < n_seq_thr:
                   continue
               else:
                   n_clusters += 1
                   newfile.write(line)
           else:
               if seq_n >= n_seq_thr:
                   newfile.write(line)
               else:
                   continue
        print n_clusters, "uncollapsed clusters found"
	file.close()
        newfile.close()


