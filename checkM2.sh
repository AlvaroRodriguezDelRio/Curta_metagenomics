#!/bin/bash
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=40G


# in /scratch/alvarordr/soft/miniforge-pypy3/
export PATH=/scratch/alvarordr/soft/miniforge-pypy3/bin/:$PATH
eval "$(conda shell.bash hook)"
conda init bash
conda activate /scratch/alvarordr/soft/miniforge-pypy3/envs/checkm2
export CHECKM2DB=/home/alvarordr/databases/CheckM2_database/uniref100.KO.1.dmnd

/scratch/alvarordr/soft/checkm2/bin/checkm2 predict --threads 10 --input out_bt/output_bins/ --output-directory checkm2_results -x fa.gz --force
