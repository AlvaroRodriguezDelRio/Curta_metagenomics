#!/bin/bash
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=3-00:00
#SBATCH --mem=100G

export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
bowtie2-build concat_contigs.min_1000_bps.fasta concat_contigs.min_1000_bps
