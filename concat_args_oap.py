import os
import pandas as pd
import sys
from collections import Counter, defaultdict

sample2gene2abs = defaultdict(lambda:Counter())
genes = set()
for f in open(sys.argv[1]):
    sample = f.split('/')[-2]
    first = True
    for line in open(f.rstrip()):
        if first:
            first = False
            continue
        gene,ab = list(map(str.strip,line.split('\t')))
        sample2gene2abs[sample][gene] = float(ab)
        genes.add(gene)


for sample in sample2gene2abs:
    for gene in genes:
        print ('\t'.join([sample,gene,str(sample2gene2abs[sample][gene])]))
