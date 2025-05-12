#!/bin/bash
#SBATCH --array=1-X # Number of metagenomic samples
#SBATCH --output logs/fastp_%a.out
#SBATCH --error logs/fastp_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=1-00:00
#SBATCH --mem=3G

export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH

###Paths to files
file1=$(cat /scratch/alvarordr/field_experiment_metagenomes/data/paths_reads_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
file2=$(echo $file1 | sed 's/_1.fq.gz/_2.fq.gz/g')
name1=$(basename $file1)
name2=$(basename $file2)
name=$(basename $file1 | sed 's/_1.fq.gz//g')

# run program
fastp -i $file1 -I $file2 -o out_fastp/$name1 -O out_fastp/$name2 --report_title $name\
        --disable_length_filtering
