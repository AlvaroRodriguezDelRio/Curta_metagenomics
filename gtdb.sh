#!/bin/bash
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=10-00:00
#SBATCH --mem=80G

# gtdb 214
export GTDBTK_DATA_PATH="/scratch/alvarordr/data/gtdb_tk_r214/release214/"
GTDBTK_DATA_PATH=/scratch/alvarordr/data/gtdb_tk_r214/release214/

gtdbtk classify_wf --genome_dir out_drep/dereplicated_genomes/ --out_dir gtdb_out_all_r214 --cpus 20 --extension fa.gz
