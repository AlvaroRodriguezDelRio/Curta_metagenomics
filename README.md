# Curta_metagenomics

Here I summarise the main steps for running a metagenomics analysis on Curta (https://www.fu-berlin.de/sites/high-performance-computing/Rechenressourcen/index.html). All the software I propose here is already installed, you could in principle run the scripts mostly as they are (after changing the number of processes to run and the location of your samples).  

# Read trimming and quality control 

Trimming reads and removing low quality sequences is needed before running any other analysis. Here is how you may do it:

```
# get paths to files where the metagenomics reads are
find $PWD/folder_with_reads/ | grep fastq | grep _1 > paths_reads.txt

# remove adapters with fastp (https://github.com/OpenGene/fastp)
mkdir scripts logs out_fastp
sbatch fastp.sh
find fastp | grep _1.fq > paths_fastp.txt

# trimmm and filter the reads
mkdir kneaddata_out
sbatch kneaddata.sh
find $PWD/kneaddata_out/ | grep -v fastqc | grep paired_1.fastq > paths_clean_1.txt
```

# Taxonomic profiling 

There are several methods for taxonomic profiling on metagenomics, some which are already installed are: 


# Functional profiling 
