# Curta_metagenomics

Here is a brief summary of the main steps for running a metagenomics analysis on Curta (https://www.fu-berlin.de/sites/high-performance-computing/Rechenressourcen/index.html). All the software I propose here is already installed, you could in principle run the scripts mostly as they are (after changing the number of samples to run and the location of your fastq files).  

# Read trimming and quality control 

Trimming reads and removing low quality sequences is needed before running any other analysis. Here is how you may do it:

```
# get paths to files where the metagenomics reads are
find $PWD/folder_with_reads/ | grep fastq | grep _1 > paths_reads.txt

# remove adapters with fastp (https://github.com/OpenGene/fastp)
mkdir scripts logs out_fastp
sbatch fastp.sh
find fastp | grep _1.fq > paths_fastp.txt

# trimmm and filter the reads with kneaddata (https://github.com/biobakery/kneaddata)
mkdir kneaddata_out
sbatch kneaddata.sh
find $PWD/kneaddata_out/ | grep -v fastqc | grep paired_1.fastq > paths_clean_1.txt
```

# Taxonomic profiling 

There are several methods for taxonomic profiling on metagenomics, some which are already installed and you can run directly are:

- Prokaryotes:
  
```
# mOTUs (https://motu-tool.org/)
mkdir motus_out
sbatch mOTUs.sh

# singleM (https://github.com/wwood/singlem)
mkdir singlem_out
sbatch singlem.sh
```

- All diversity levels

```
# kraken2 
mkdir out_kraken
sbatch kraken2.sh

```
# Functional profiling 

For functional profiling, there are tools for detecting general functional genes, and specific for antibiotic resistance genes.

```
# general functional genes with funprofiler (https://github.com/KoslickiLab/fmh-funprofiler)
mkdir out_funprofiler
sbatch funprofiler.sh

# ARGs with arg-oap (https://github.com/xinehc/args_oap)
mkdir out_args
sbatch arg_oap.sh

```
