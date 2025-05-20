#!/bin/bash
#SBATCH --array=1-N_SAMPLES
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=10:00:00
#SBATCH --mem=1G


###Paths to files
file1=$(cat paths_kraken.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/.kraken_annots.sp.tab//g')
file2=$(echo $file1 | sed 's/.kraken_annots.sp.tab/.species2lin.tab/g')

python scripts/abs_per_lin.kraken.py $file2 $file1 > out_kraken/$name.abs_per_lin.tab
