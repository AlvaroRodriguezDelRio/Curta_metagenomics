#!/bin/bash
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=130G

export PATH=/scratch/alvarordr/soft/miniforge-pypy3/bin/:$PATH
conda init
conda activate SemiBin

mkdir out_semibin/

SemiBin2 multi_easy_bin \
-i contigs.concatenated.min_1kbps.fa \
-b out_bt/*sorted.bam \
-o out_semibin/ -p 10
