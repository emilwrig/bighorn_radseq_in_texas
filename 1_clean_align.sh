#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=rad_align
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=8
#SBATCH --time=48:00:00
#SBATCH --array=1-396

# set up variables for this project
workdir=/lustre/scratch/emilwrig/bighorn/final_analyses_aug2023
reference_genome=/lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/genome/GCF_016772045.1_ARS-UI_Ramb_v2.0_genomic.fna
array_input=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/info/list.txt | tail -n1 )

module load stacks/2.65

# filter the data with the STACKS process radtags script
process_radtags -1 /lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/00_fastq/${array_input}_R1_001.fastq.gz -2 /lustre/scratch/emilwrig/bighorn/final_analyses_aug2023/00_fastq/${array_input}_R2_001.fastq.gz -o ${workdir}/01_cleaned -e ecoRI -c -q 

# trim the first 5 bp off (cut site)
trimmomatic SE -threads 1 -phred33 ${workdir}/01_cleaned/${array_input}_R1_001.1.fq.gz ${workdir}/01_cleaned/${array_input}_R1.fastq.gz HEADCROP:5
trimmomatic SE -threads 1 -phred33 ${workdir}/01_cleaned/${array_input}_R2_001.2.fq.gz ${workdir}/01_cleaned/${array_input}_R2.fastq.gz HEADCROP:5

# load new gcc and bwa because bwa requires a different gcc version?
module load gcc/9.2.0 bwa/0.7.17

# align to reference using bwa
bwa mem -t 8 ${reference_genome} ${workdir}/01_cleaned/${array_input}_R1.fastq.gz ${workdir}/01_cleaned/${array_input}_R2.fastq.gz > ${workdir}/02_bam/${array_input}.sam

# switch modules again
module load gcc/10.1.0 samtools

# convert sam to bam
samtools view -b -S -o ${workdir}/02_bam/${array_input}.bam ${workdir}/02_bam/${array_input}.sam

# sort the bam file
samtools sort ${workdir}/02_bam/${array_input}.bam > ${workdir}/02_bam/${array_input}_sorted.bam

# remove the unneeded sam and bam and fastq files
rm ${workdir}/02_bam/${array_input}.sam
rm ${workdir}/02_bam/${array_input}.bam
rm ${workdir}/01_cleaned/${array_input}_R1_001.1.fq.gz
rm ${workdir}/01_cleaned/${array_input}_R2_001.2.fq.gz
rm ${workdir}/01_cleaned/${array_input}_R1_001.rem.1.fq.gz
rm ${workdir}/01_cleaned/${array_input}_R2_001.rem.2.fq.gz
