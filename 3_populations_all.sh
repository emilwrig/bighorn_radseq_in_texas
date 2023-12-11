#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=POPS
#SBATCH --output=%x.o%j
#SBATCH --error=%x.o%j
#SBATCH --partition nocona
#SBATCH --nodes=1
#SBATCH --ntasks=128

module load stacks/2.65

DIR="/lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/04_populations"
RUNNAME="populations_90"
POPMAP="/lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/info/popmap.txt"
SORTED="/lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/03_stacks"
mkdir $DIR
cd $DIR
mkdir $RUNNAME

populations -P $SORTED --popmap $POPMAP -O ./$RUNNAME  -R 0.90 -t 32 --vcf --structure --hwe 

echo "Done"

