#!/bin/bash
#SBATCH --array=1-NUM_SAMPLES
#SBATCH --output logs/kneaddata_%a.out
#SBATCH --error logs/kneaddata_%a.error
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=10-00:00
#SBATCH --mem=50G


###Paths to files
#file1=$(cat paths_fastp.sh | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
file1=$(cat paths_fastp.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
file2=$(echo $file1 | sed 's/_1.fq.gz/_2.fq.gz/g')
name1=$(basename $file1 | sed 's/.fq.gz//g')
name2=$(basename $file2 | sed 's/.fq.gz//g')


# May need to format file names so that they have a _1 and _2 at the end, otherwise the program does not work
zcat $file1 | sed 's/ 1.*/\/1/g' > fastq_name_format/${name1}.fastq
zcat $file2 | sed 's/ 2.*/\/2/g' > fastq_name_format/${name2}.fastq

# run program
export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
kneaddata --input1 fastq_name_format/${name1}.fastq --input2 fastq_name_format/${name2}.fastq\
                --run-trim-repetitive\
                --threads 1\
                --trf /scratch/alvarordr/soft/miniconda3/bin/\
                --trimmomatic /scratch/alvarordr/soft/Trimmomatic-0.39/\
                --trimmomatic-options "SLIDINGWINDOW:4:20 MINLEN:50"\
                --trimmomatic-options="LEADING:3" --trimmomatic-options="TRAILING:3"\
                --bowtie2 /scratch/alvarordr/soft/miniconda3/bin/\
                -db /scratch/alvarordr/soft/kneaddata/db/human_genome\
                --sequencer-source none\
                --output kneaddata_out\
                --fastqc /scratch/alvarordr/soft/miniforge-pypy3/bin/\
                --run-fastqc-end


rm fastq_name_format/${name1}.fastq
rm fastq_name_format/${name2}.fastq
