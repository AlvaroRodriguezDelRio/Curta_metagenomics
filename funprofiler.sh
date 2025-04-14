#!/bin/bash
#SBATCH --array=1-N_SAMPLES
#SBATCH --output logs/%A_%a.out
#SBATCH --error logs/%A_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=2-00:00
#SBATCH --mem=20G


export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH
conda init bash
conda activate /scratch/alvarordr/soft/miniconda3_scapp/envs/funcprofiler

###Paths to files
file1=$(cat  paths_clean_1.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
name=$(basename $file1 | sed 's/_kneaddata_paired_1.fastq//g')
file2=$(echo $file1 | sed 's/_kneaddata_paired_1.fastq/_kneaddata_paired_2.fastq/g')

# concat (see https://github.com/KoslickiLab/fmh-funprofiler/issues/11)
cat $file1 $file2 > concat/$name.fastq

# run
python /scratch/alvarordr/soft/funprofiler/funcprofiler.py concat/$name.fastq /scratch/alvarordr/soft/funprofiler/KOs_sbt_scaled_1000_k_11.sbt.zip 11 1000 out_funprofiler/$name.csv

# delete concat
rm concat/$name.fastq
