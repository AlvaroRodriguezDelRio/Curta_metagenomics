#!/bin/bash
#SBATCH --array=1-303
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=10G

###Paths to files
file1=$(cat paths_proteins.txt  | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/.faa//g')

export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH
mkdir out_emapper

#/scratch/alvarordr/soft/miniconda3/bin/emapper.py --cpu 1 -i $file1 --itype proteins --annotate_hits_table $file1.annots.tab -o $file1.out_emapper.tab --override --block_size 0.4
~/soft/miniconda3/bin/emapper.py --cpu 1 -i $file1 --itype proteins -o out_emapper/$name.out_emapper.tab --block_size 0.4  --data_dir /home/alvarordr/emapper_db/data 
