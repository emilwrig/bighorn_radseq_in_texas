#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=2017
#SBATCH --output=%x.o%j
#SBATCH --error=%x.o%j
#SBATCH --partition nocona
#SBATCH --nodes=1
#SBATCH --ntasks=128

module load stacks/2.65

DIR="/lustre/scratch/emilwrig/elephant_mountain/04_populations_EM2017"
RUNNAME="populations_90"
POPMAP="/lustre/scratch/emilwrig/elephant_mountain/EM2017_popmap.txt"
SORTED="/lustre/scratch/emilwrig/elephant_mountain/03_stacks"
mkdir $DIR
cd $DIR
mkdir $RUNNAME

populations -P $SORTED --popmap $POPMAP -O ./$RUNNAME  -R 0.90 -t 32 --vcf --structure --hwe 

echo "Done"
