#!/bin/bash
#SBATCH --array=1-N_samples
#SBATCH --output logs/bowtie_%a.out
#SBATCH --error logs/bowtie_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=80G

export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH

###Paths to files
file1=$(cat paths_clean_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/_kneaddata_paired_1.fastq//g')
file2=$(echo $file1 | sed 's/paired_1/paired_2/g')
fileu1=$(echo $file1 | sed 's/paired_1/unmatched_1/g')
fileu2=$(echo $file1 | sed 's/paired_1/unmatched_2/g')

bowtie2 -x out_bt/db -1 $file1 -2 $file2  -S out_bt/$name.sam
samtools view -b out_bt/$name.sam > out_bt/$name.bam
samtools sort out_bt/$name.bam -o out_bt/$name.sorted.bam

rm  out_bt/$name.bam
rm out_bt/$name.sam
