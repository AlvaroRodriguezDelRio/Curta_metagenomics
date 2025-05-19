# Curta_metagenomics

Here is a brief summary of the main steps for running a metagenomics analysis on Curta (https://www.fu-berlin.de/sites/high-performance-computing/Rechenressourcen/index.html). All the software I propose here is already installed, you could in principle run the scripts mostly as they are. The only thing you need to modify in your scripts is:
-  The number of samples to run by changing the ```#SBATCH --array=1-X``` line , being X the number of samples you have

Before starting, clone this repository to the directory where you wanna perform the analysis, using 

```
git clone https://github.com/AlvaroRodriguezDelRio/Curta_metagenomics.git
cd Curta_metagenomics
```

# Read trimming and quality control 

Trimming reads and removing low quality sequences is needed before running any other analysis. Here is how you may do it:

```
# initial preparation
export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
conda init bash

# get paths to files where the metagenomics reads are
find $PWD/folder_with_reads/ | grep fastq | grep _1 > paths_reads.txt

# create folders
mkdir logs out_fastp

# remove adapters with fastp (https://github.com/OpenGene/fastp)
mkdir out_fastp
sbatch fastp.sh
find out_fastp | grep _1.fq > paths_fastp.txt

# trimmm and filter the reads with kneaddata (https://github.com/biobakery/kneaddata)
mkdir kneaddata_out
sbatch kneaddata.sh
find $PWD/kneaddata_out/ | grep -v fastqc | grep paired_1.fastq > paths_clean_1.txt
```

# Taxonomic profiling 

There are several methods for taxonomic profiling on metagenomics, some which are already installed and you can run directly are:

- Prokaryotes:
  
```
####
# mOTUs (https://motu-tool.org/)
###

# run motus
mkdir motus_out
sbatch mOTUs.sh

# format headers for concatenating
mkdir motus_out_headers
for i in motus_out/*; do n=$(basename $i);  python format_motus_file.py $i > motus_out_headers/$n; done

# concatenate 
export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
motus merge -d motus_out_headers/ > motus_merged.tab

###
# singleM (https://github.com/wwood/singlem)
###

mkdir out_singlem
sbatch singlem.sh
```

- All diversity levels

```
# kraken2 
mkdir out_kraken
sbatch kraken2.sh

```
# Functional profiling 

For functional profiling (calculating the relative abundances of functional genes), there are tools for detecting general functional genes, and specific for antibiotic resistance genes.

```
###
# general functional genes with funprofiler (https://github.com/KoslickiLab/fmh-funprofiler)
###

# run 
mkdir out_funprofiler
sbatch funprofiler.sh

# concat output
find out_funprofiler | grep csv > paths_funprofiler.txt
python concat_funprofiler.py paths_funprofiler.txt > paths_funprofiler.concat.txt


# ARGs with arg-oap (https://github.com/xinehc/args_oap)
mkdir out_args
sbatch arg_oap.sh

# concatenate into single files
# there are several files (per type / per gene, normialized by copy number per cell, ...)
# in this example, you will concatenate copy number of different ARG types per cell 
find  out_args/ | grep normalized_cell.type.txt > paths_normalized_cell.type.rare.txt
python concat_args_oap.py  paths_normalized_cell.type.rare.txt > args_oap.normalized_cell.type.concat.tab
```

# Genome size estimation 

It is also possible to estimate average genome size of microbial communities on metagenomic samples, here is how


```
mkdir out_MicrobeCensus
sbatch MicrobeCensus.sh
```
