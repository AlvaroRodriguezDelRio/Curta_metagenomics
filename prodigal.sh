#!/bin/bash
#SBATCH --array=1-#N_SAMPLES
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=2G

export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH

mkdir gff proteins cds

###Paths to files
file1=$(cat  ../assembly/megahit/paths_chunks.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1)
prodigal -i $file1 -o gff/$name.gff -a proteins/$name.faa -d cds/$name.fna -p meta -f gff
