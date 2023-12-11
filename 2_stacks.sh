#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=STACKS
#SBATCH --output=%x.o%j
#SBATCH --error=%x.o%j
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=128



# What you need to do:
# 1. Edit locations for BAM files, POPMAP, and OUTPUT
# 2. If you do not have a stacks directory, this script will make it
# 3. This uses the Popmap text file rather than the list text file


BAMS="/lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/02_bam"
POPMAP="/lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/info/popmap.txt"
OUTPUT="/lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/03_stacks"

module load stacks/2.65

gstacks -I $BAMS -S _sorted.bam -M $POPMAP -O $OUTPUT -t 128
