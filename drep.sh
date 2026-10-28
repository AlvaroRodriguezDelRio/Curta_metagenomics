#!/bin/bash
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=1G

/scratch/alvarordr/soft/drep/bin/dRep dereplicate out_drep -g all_bins/*gz  --ignoreGenomeQuality
