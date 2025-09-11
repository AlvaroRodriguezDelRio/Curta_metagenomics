import sys
import re


for f in open(sys.argv[1]):
    f = f.rstrip()
    s_name = f.split('/')[-1].replace('.fasta','')
    for line in open(f):
        line = line.rstrip()
        if re.search('>',line):
            g = line.replace('>','').split(' ')[0]
            g_new = s_name + ":" + g
            print (">" + g_new)
        else:
            print (line)
