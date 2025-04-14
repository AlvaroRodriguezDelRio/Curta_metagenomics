#!/bin/bash
#SBATCH --array=1-N_samples
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=1-00:00
#SBATCH --mem=10G

export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH
conda activate /scratch/alvarordr/soft/miniconda3_scapp/envs/singlem

###Paths to files
file1=$(cat paths_clean_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
file2=$(echo $file1 | sed 's/paired_1/paired_2/g')
name=$(basename $file1 | sed 's/_kneaddata_paired_1.fastq.gz//g')

export SINGLEM_METAPACKAGE_PATH='/scratch/alvarordr/data/singlem/S3.2.1.GTDB_r214.metapackage_20231006.smpkg.zb'
singlem pipe -1 $file1 -2 $file2 -p out_singlem/$name.tsv
