#!/bin/bash
#SBATCH --output logs/CARD.out
#SBATCH --error logs/CARD.error
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --qos=standard
#SBATCH --time=1-00:00
#SBATCH --mem=100G


/scratch/alvarordr/soft/diamond blastp\
        -d /scratch/alvarordr/data/CARD/protein_fasta_protein_homolog_model_dmd.dmnd\
        -q proteins.faa -o mappings.tab --sensitive -p 10\
        --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovhsp scovhsp qlen slen\
        --max-target-seqs 0
