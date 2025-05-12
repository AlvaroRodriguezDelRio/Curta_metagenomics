#!/bin/bash
#SBATCH --array=1-N_SAMPLES
#SBATCH --output logs/motus_%a.out
#SBATCH --error logs/motus_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=2-00:00
#SBATCH --mem=15G


export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH

###Paths to files
file1=$(cat paths_clean_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/_kneaddata_paired_1.fastq//g')
file2=$(echo $file1 | sed 's/paired_1/paired_2/g')
fileu1=$(echo $file1 | sed 's/paired_1/unmatched_1/g')
fileu2=$(echo $file1 | sed 's/paired_1/unmatched_2/g')

#-c flag changes the output from relative abundance to number of assigned reads
# -A print all taxonomic levels together (kingdom to mOTUs, override -k)
# -q print the full rank taxonomy
# -u print the full name of the species
#   -e               only species with reference genomes (ref-mOTUs)

motus profile -f $file1 -r $file2 -s $fileu1,$fileu2 -t 1 -A -q  > motus_out/$name.rel.tab
