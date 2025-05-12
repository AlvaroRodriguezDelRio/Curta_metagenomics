#!/bin/bash
#SBATCH --array=1-NSAMPLES
#SBATCH --output logs/arg_oap_%a.out
#SBATCH --error logs/arg_oap_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=10-00:00
#SBATCH --mem=30G

export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH

###Paths to files
file1=$(cat paths_clean_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
file2=$(echo $file1 | sed 's/_1.fastq/_2.fastq/g')
name=$(basename $file1 | sed 's/_1_kneaddata_paired_1.fastq//g')

mkdir temp_fastq/$name
cp $file1 temp_fastq/$name/
cp $file2 temp_fastq/$name/

args_oap stage_one -i temp_fastq/$name -o out_args/$name -f fastq -t 1
args_oap stage_two -i out_args/$name -t 1

rm  temp_fastq/$name/$file1
rm  temp_fastq/$name/$file2
