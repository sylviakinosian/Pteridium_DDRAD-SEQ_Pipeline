#! /usr/bin/python
#
# this script reads through a file of sample ids (or something) and moves the respective files
#into a different folder (see line 24) the source path will be given as the second command line
#argument

#Usage: ~/gbs_tools/move_taxa.py ids.txt source/path

from sys import argv
from shutil import copy
from os import listdir
#from re import findall

files = listdir(argv[2])

# print(ITSfiles)

with open(argv[1], 'rb') as file:
    for i, line in enumerate(file):
        line = line.split('\n')[0:]
        ids = str(line[0] + ".fasta")
        #print ids
        #print line
        #print ", ".join(files) # line[0]
        #print findall(line[0], files)
        #print type()
        if ids in set(files):
            filepath = str(argv[2] + ids)
            #print filepath
            copy(filepath,
                    '/home/skinosian/Documents/pteridium/cluster/escu_inds/fasta')
        else:
            print "%s not found" % line[0]
