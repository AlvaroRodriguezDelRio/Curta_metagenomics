# Curta_metagenomics

Here is a brief summary of the main steps for running a metagenomics analysis on Curta, the computing cluster within the FU (https://www.fu-berlin.de/sites/high-performance-computing/Rechenressourcen/index.html).  

## Before metagenomics

First step is to ask for an account in Curta. You can do that here: https://ssl2.cms.fu-berlin.de/fu-berlin/en/sites/high-performance-computing/PM_Zugang-beantragen/index.html 

After you have your account, you can acess by typing `ssh user_name@curta.zedat.fu-berlin.de` and your password. This will access your `/home/user_name` directory. the `/home` partition is small, and should not be used for doing analysis, just to store final results. You can doyour analysis in `/scratch/user_name/`. 

For copying data from / to the cluster, you can use the `scp` command from your local computer. 
- For downloading data: `scp user_name@curta.zedat.fu-berlin.de:your_data_location_in_curta directory_where_you_want_to_donwload_the_data`
- For uploading data: `scp location_of_the_data user_name@curta.zedat.fu-berlin.de:directory_where_you_want_to_upload_the_data`

Something important to do after your sequences arrive is to create a back-up (`/scratch/` is not baked-up). You can do that by copying the data to `/remote/trove/bcp/rilliglab/`, in a directory with your user name. 

## Download repository

Clone this repository to the directory where you want to perform the analysis (somewhere under your ```/scratch/user_name/``` directory), using:

```
git clone https://github.com/AlvaroRodriguezDelRio/Curta_metagenomics.git
cd Curta_metagenomics
export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
conda init bash
mkdir logs
```

The only thing you need to modify in your `.sh` scripts is:
- The number of samples to run by changing the ```#SBATCH --array=1-X``` line , being X the number of samples you have
- The formatting of your sample names, in the declaration of the `file2` and `name` variables.
- Software parameters (defaults are usually working well)

Some python scripts also assume certain file name terminations, which may need to be changed. 

## Read trimming and quality control 

Trimming reads and removing low quality sequences is needed before running any other analysis. Here is how you may do it:

```
# get paths to files where the metagenomics reads are
# you may need to change here the grep command for filtering the reads from the first pass (.1, /1, _1 are common names)
find $PWD/folder_with_reads/ | grep fastq | grep _1 > paths_reads.txt

# remove adapters with fastp (https://github.com/OpenGene/fastp)
mkdir out_fastp
sbatch fastp.sh
find out_fastp | grep _1.fq > paths_fastp.txt

# trimmm and filter the reads with kneaddata (https://github.com/biobakery/kneaddata)
mkdir kneaddata_out fastq_name_format
sbatch kneaddata.sh
find $PWD/kneaddata_out/ | grep -v fastqc | grep paired_1.fastq > paths_clean_1.txt
```

## Taxonomic profiling 

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
for i in motus_out/*; do n=$(basename $i);  python format_motus_files.py $i > motus_out_headers/$n; done

# concatenate 
export PATH=/scratch/alvarordr/soft/miniconda3/bin/:$PATH
motus merge -d motus_out_headers/ > motus_merged.tab
rm -rf motus_out_headers

###
# singleM (https://github.com/wwood/singlem)
###

# run 
export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH
conda activate /scratch/alvarordr/soft/miniconda3_scapp/envs/singlem
mkdir out_singlem
sbatch singlem.sh

# concatenate
cat out_singlem/* | grep -v sample > singleM.tab

```

- All diversity levels (viruses, prokaryotes, eukaryotes)


```
###
# kraken2 
###

# run 
mkdir out_kraken
sbatch kraken2.sh

# get abundance per lineage 
find out_kraken/ | grep kraken_annots.sp.tab > paths_kraken.txt

# concatenate
srun --qos=standard --mem=10G -n 1 -t 10:00:00  python concatenate.kraken.py out_kraken/*abs_per_lin.tab > kraken.tab
```
## Functional profiling 

For functional profiling (calculating the relative abundances of functional genes), there are tools for detecting general functional genes, and specific for antibiotic resistance genes.

```
###
# general functional genes with funprofiler (https://github.com/KoslickiLab/fmh-funprofiler)
###

# prepare
export PATH=/scratch/alvarordr/soft/miniconda3_scapp/bin/:$PATH
conda activate /scratch/alvarordr/soft/miniconda3_scapp/envs/funcprofiler

# run 
mkdir out_funprofiler
sbatch funprofiler.sh

# concatenate output
find out_funprofiler | grep csv > paths_funprofiler.txt
python concat_funprofiler.py paths_funprofiler.txt > paths_funprofiler.concat.txt

####
# ARGs with arg-oap (https://github.com/xinehc/args_oap)
####

# run
mkdir out_args
sbatch arg_oap.sh

# concatenate into single files
# there are several files (per type / per gene, normialized by copy number per cell, ...)
# in this example, you will concatenate copy number of different ARG types per cell 
find  out_args/ | grep normalized_cell.type.txt > paths_normalized_cell.type.rare.txt
python concat_args_oap.py  paths_normalized_cell.type.rare.txt > args_oap.normalized_cell.type.concat.tab
```

## Genome size estimation 

It is also possible to estimate average genome size of microbial communities on metagenomic samples, here is how


```
# run 
mkdir out_MicrobeCensus
sbatch MicrobeCensus.sh

# concatenate
find out_MicrobeCensus | grep tab > paths_MicrobeCensus.txt
python concatenate.MicrobeCensus.py paths_MicrobeCensus.txt > MicrobeCensus.txt
```


## Assembly

The next step in the typical metagenomic workflow is to assemble the short reads into longer contigs. For doing so, a Megahit (https://github.com/voutcn/megahit) is a popular software  

```
# run 
mkdir out_megahit
sbatch megahit.sh

# get results & concatenate (adding sample name to fasta headers) 
find $PWD/out_megahit/ | grep final.contigs.fa | grep -v interm > paths_contigs.txt
python concat_assembly.add_sample_name.py paths_contigs.txt > contigs.concatenated.fa

# Dircard very short contigs (< 1k bps)
/scratch/alvarordr/soft/miniconda3_scapp/bin/seqkit  seq -m 1000 contigs.concatenated.fa > contigs.concatenated.min_1kbps.fa

```

## MAG building 

We can now build MAGs on the assemblies. For that , we will use the SemiBin software (https://academic.oup.com/bioinformatics/article/39/Supplement_1/i21/7210480). For that, we first need to map the reads back to the assemblies, for which we will use bowtie2

```
# build bowtie2 index 
mkdir out_bt/
sbatch bowtie_db.sh

# maps reads to bowtie database
sbatch bowtie.sh

# run semiin 
export PATH=/scratch/alvarordr/soft/miniforge-pypy3/bin/:$PATH
conda activate SemiBin
mkdir out_semibin/

sbatch semibin.sh
```

## Gene prediction and functional annotation 

```


```



