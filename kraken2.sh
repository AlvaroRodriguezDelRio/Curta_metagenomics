#!/bin/bash
#SBATCH --array=1-N_SAMPLES
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=14-00:00
#SBATCH --mem=100G


export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH

###Paths to files
file1=$(cat paths_clean_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/_kneaddata_paired_1.fastq//g')
file2=$(echo $file1 | sed 's/paired_1/paired_2/g')
fileu1=$(echo $file1 | sed 's/paired_1/unmatched_1/g')
fileu2=$(echo $file1 | sed 's/paired_1/unmatched_2/g')

/scratch/alvarordr/soft/miniconda_2024/bin/kraken2 --db /scratch/alvarordr/soft/kraken_db/k2_pluspf_20230605/ --paired $file1 $file2 --use-names  >  out_kraken/$name.kraken_annots.sp.tab
/scratch/alvarordr/soft/miniconda_2024/bin/kraken2 --db /scratch/alvarordr/soft/kraken_db/k2_pluspf_20230605/ --paired $file1 $file2 --use-names --use-mpa-style --report out_kraken/$name.species2lin.tab
