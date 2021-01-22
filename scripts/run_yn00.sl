#!/bin/bash 
#SBATCH --job-name=run_yn00
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=5M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 

module load StdEnv/2020
module load gcc/9.3.0
module load intel/2020.1.217
module load paml/4.9j

mito_aln="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna/cat_mitoch_genes.fna"

#symb_aln=''

cd ~/scratch/Clams/dnds


echo "
## Run YN00 ##
"

yn00 /home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/scripts/mito_yn00.ctl >> mito.log