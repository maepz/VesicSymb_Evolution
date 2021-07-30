#!/bin/bash 
#SBATCH --job-name=codeml
#SBATCH --account=def-bacc
#SBATCH --time=12:0:0
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --error=%x_%A_%a'.err' 
#SBATCH --output=%x_%A_%a'.out' 
#SBATCH --array=0-4

module load StdEnv/2020  gcc/9.3.0
module load paml/4.9j

cd /home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/cat_alignments/codeml/symb/BM${SLURM_ARRAY_TASK_ID} 

codeml codeml.ctl
