#!/bin/bash
#SBATCH --array=1-26
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=extended
#SBATCH --time=10-00:00
#SBATCH --mem=50G

export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH
export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
export PATH=/scratch/alvarordr/soft/miniforge-pypy3/bin/:$PATH

###Paths to files
file1=$(cat paths_clean_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/_1_kneaddata_paired_1.fastq//g')
file2=$(echo $file1 | sed 's/paired_1.fastq/paired_2.fastq/g')

# some params from
# https://bio-protocol.org/exchange/minidetail?type=30&id=8858696

coverm genome -1 $file1 -2 $file2 --genome-fasta-list paths_drep.mq.txt -p bwa-mem --min-read-percent-identity 95 --min-read-aligned-percent 75 -o out_coverM/$name.tab --threads 1
