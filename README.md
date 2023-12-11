# bighorn_radseq_in_texas

Use these scripts in numerical order to analyze the raw read files in the BioProjects PRJNA940156 and PRJNA1045804.

METHODS

1_clean_align.sh -> takes raw reads, removes the EcoRI restriction enzyme, aligns to reference genome

2_stacks.sh -> takes resulting bam files for input into Stacks and produces files for the populations script

3_populations90.sh -> uses the output from Stacks to produce vcf file for further filtering
