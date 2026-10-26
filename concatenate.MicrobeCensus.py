import sys
import re

for f in open(sys.argv[1]):
    f = f.rstrip()
    sample = f.split('/')[-1].replace('.gz.tab','')
    for line in open(f):
        print ('\t'.join([sample,line.rstrip()]))
