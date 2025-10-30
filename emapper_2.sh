#!/bin/bash
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=5G


export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH

/home/alvarordr/soft/miniconda3/bin/emapper.py --annotate_hits_table  all.seed_orthologs --no_file_comments -o all_annotations --cpu 10  --data_dir /scratch/alvarordr/soft/miniconda3/lib/python3.10/site-packages/data/ 
