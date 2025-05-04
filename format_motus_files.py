import sys

h = True
s_name = sys.argv[1].rstrip().split('/')[-1].split('_')[0]
for line in open(sys.argv[1]):
    if h:
        f_col = line.rstrip().split('\t')[0]
        print(f_col + '\t' + s_name)
        h = False
    else:
        print(line.rstrip())
