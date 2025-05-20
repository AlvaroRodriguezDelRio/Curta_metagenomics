import sys
from collections import defaultdict,Counter


for f in sys.argv[1:]:
    sample2n = Counter()
    sample = f.split('/')[-1].replace('.kraken_annots.lin.tab','')
    for line in open(f):
        line = line.rstrip()
        if len(list(map(str.strip,line.split('\t')))) < 5:
            continue
        u,read,annot,u1,u2 = list(map(str.strip,line.split('\t')))
        t_comb = []
        for t in annot.split('|'):
            t_comb.append(t)
            sample2n['|'.join(t_comb)] += 1
    for t,n in sample2n.items():
        print ('\t'.join([sample,t,str(n)]))
