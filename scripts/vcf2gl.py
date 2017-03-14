#! /usr/bin/python


# This scripts converts a vcf file to a simpler format for downstream analyses.
# Zach Gompert is calling this format genotype likelihood (gl). The first line
# lists the number of individuals and loci. The next line has individual ids.
# This is followed by one line per SNP that gives the SNP id (scaffold,
# position) and the phred-scaled genotype likelihoods, three per individual.
# A separate file with the allele frequency for each locus is being written.
# This version does not yet include a filter for maf.
#
# Usage: ./vcf2gl.py filtered_vcf_file.vcf ref_allele_freqs.txt alt_allele_freqs.txt > outfile.gl


import sys
import re
from collections import OrderedDict


rf_file = open(sys.argv[2], 'a')
af_file = open(sys.argv[3], 'a')

with open(sys.argv[1], 'rb') as file:
    n_snv = 0
    n_no_num = 0
    n_num = 0
    line_dict = dict()
    for line in file:
        if line[0:2] == '##':
            continue
        elif line[0:2] == '#C':
            header = line.split('\n')[0].split('\t')
            ind_ids = header[9:len(header)]
            #print line, header, ind_ids
        else:
            line_list = line.split('\t')
            if len(line_list[4]) > 1:
                continue
            else:
                geno_likely = OrderedDict()
                n_snv += 1
                n_ind = len(ind_ids)
                scaffold = line_list[0].split('d')[1]   # if "ScaffoldXXX"
                #scaffold = line_list[0].split('-')[1]    # if vsearch
                pos = line_list[1]
                snv_id = ':'.join([scaffold, pos])
                af = re.findall('AF=[0.0-9.0a-z\-]+', line_list[7])
                af = float(af[0].split('=')[1])
                rf = 1 - af
                af_line = str(snv_id + ' ' + str(af) + '\n')
                af_file.write(af_line)
                rf_line = str(snv_id + ' ' + str(rf) + '\n')
                rf_file.write(rf_line)
                for j, ind in enumerate(ind_ids):
                    if line_list[j+9][0:3] == './.':
                        rr, ra, aa = map(str,[0, 0, 0])
                        ind_line = str(rr + ' ' + ra + ' ' + aa)
                        n_no_num += 1
                        geno_likely[ind] = ind_line
                    else:
                        n_num += 1
                        gt_lklhd = line_list[j+9].split(':')
                        lklhd = gt_lklhd[4].split('\n')[0]
                        rr, ra, aa = lklhd.split(',')
                        ind_line = str(rr + ' ' + ra + ' ' + aa)
                        geno_likely[ind] = ind_line
                    line_dict[snv_id] = ' '.join(geno_likely.values())
    file.close()
    af_file.close()
    rf_file.close()


print n_ind, n_snv #, n_no_num, n_num
print ' '.join(map(str, ind_ids))
it = iter(sorted(line_dict.iteritems()))
for key, value in it:
    print key, value


