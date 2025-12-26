#!/bin/bash
#SBATCH --array=1-NSAMPLES
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 30
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=150G

export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH

###Paths to files
file1=$(cat  paths_clean_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/_kneaddata_paired_1.fastq//g')
file2=$(echo $file1 | sed 's/_kneaddata_paired_1.fastq/_kneaddata_paired_2.fastq/g')


rm -rf out_megahit/$name
/scratch/alvarordr/soft/MEGAHIT-1.2.9-Linux-x86_64-static/bin/megahit -1 $file1 -2 $file2 -o out_megahit/$name -m 0.90 --mem-flag 1 -t 30
