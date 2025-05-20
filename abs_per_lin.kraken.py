import sys
import re

sp2lin = {}
for line in open(sys.argv[1]):
    sp,code = list(map(str.strip,line.split('\t')))
    for s in sp.split('|'):
        sp2lin[s.split('_')[2]] = sp


for line in open(sys.argv[2]):
    u,read,sp,n1,n2 = list(map(str.strip,line.split('\t')))
    sp = sp.split('(')[0].rstrip()
    if sp == 'unclassified':
        sp = 'unclassified'
    else:
        if sp in sp2lin:
            sp = sp2lin[sp]
        elif sp.split(' ')[0] in sp2lin:
            sp = sp2lin[sp.split(' ')[0]]
        elif len(sp.split(' ')) > 1:
            if sp.split(' ')[1] in sp2lin:
                sp = sp2lin[sp.split(' ')[1]]
    print ('\t'.join([u,read,sp,n1,n2]))
