#!/bin/bash
#SBATCH --array=1-NSAMPLES
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=prio
#SBATCH --time=3:00:00
#SBATCH --mem=1G

export PATH=/scratch/alvarordr/soft/miniforge-pypy3/bin:/scratch/alvarordr/soft/miniforge/bin:/scratch/alvarordr/soft/miniforge-pypy3/bin:/scratch/alvarordr/soft/miniforge-pypy3/condabin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/alvarordr/.dotnet/tools:/scratch/alvarordr/soft/mocat2/stable/2.1.3/src:/home/alvarordr/.local/bin:/home/alvarordr/bin:/scratch/alvarordr/soft/mocat2/stable/2.1.3/src

file1=$(cat  paths_samples.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/_1.fastq//g')
file2=$(echo $file1 | sed 's/_1.fastq/_2.fastq/g')


python /scratch/alvarordr/field_experiment_metagenomes/analysis/MicrobeCensus/scripts/microbecensus.py $file1 $file2 > out/$name.tab
