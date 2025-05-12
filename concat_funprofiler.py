import sys
import re


ko2d = {i.rstrip().split('\t')[0]:i.rstrip().split('\t')[1] for i in open('/scratch/alvarordr/data/kos.tab')}


for f in open(sys.argv[1]):
    f = f.rstrip()
    sample = f.split('/')[-1].replace('.csv','')
    for line in open(f):
        ko = line.split(',')[0].replace('ko:','').rstrip()
        count =  line.split(',')[1].rstrip()
        desc = '-'
        if ko in ko2d:
            desc = ko2d[ko].rstrip()
        print ('\t'.join([sample,ko,count,desc]))
