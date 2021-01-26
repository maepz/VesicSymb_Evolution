#!/bin/bash 
#SBATCH --job-name=run_array_absrel
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=800M
#SBATCH --error=%x_%A_%a'.err' 
#SBATCH --output=%x_%A_%a'.out' 
#SBATCH --array=473


module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load hyphy/2.5.26

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_ABSREL="/home/maeperez/scratch/Clams/hyphy2.5/absrel"

SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist_nopseudo_638 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

#echo " make tree"

#(echo 13; echo 3; echo 2; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo GRM; echo 2; echo 2; echo y; echo ${PATH_PHYLOGENY}/${SAMPLE}.tree;) | mpirun -np $SLURM_NTASKS HYPHYMPI

#3,5,4,2


echo "## aBSREL ## "

(echo 1; echo 6; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.tree) | mpirun -np $SLURM_NTASKS HYPHYMPI

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.ABSREL.json ${PATH_ABSREL}/${SAMPLE}.absrel.json
