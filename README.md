# Curta_metagenomics

Main steps for metagenomics analysis on curta

# Read trimming and quality control 

```
# get paths to files where reads are
find $PWD/folder_with_reads/ | grep fastq | grep _1 > paths_reads.txt

# remove adapters
mkdir scripts logs out_fastp
sbatch fastp.sh
find fastp | grep _1.fq > paths_fastp.txt

# trimmm and filter the reads


```

# Taxonomic profiling 

# Functional profiling 
