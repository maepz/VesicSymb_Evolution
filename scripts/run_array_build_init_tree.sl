#!/bin/bash 
#SBATCH --job-name=run_array_build_init_tree
#SBATCH --account=def-bacc
#SBATCH --time=0:10:0
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=500M
#SBATCH --error=%A'.err' 
#SBATCH --output=%A'.out' 
#SBATCH --array=1-336 

module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14

cd /home/maeperez/scratch/VesicSymb_Evolution/

#PATH_ALN="/home/maeperez/VesicSymb_Evolution/mauve_alignments/fna"
PATH_ALN="/home/maeperez/VesicSymb_Evolution/mauve_alignments/Outgroup/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/VesicSymb_Evolution/init_trees"


#SAMPLE="Rmag_0001"
SAMPLE=$(sed 's/,.*//' $PATH_ALN/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"


echo "
## build inital tree ##
"

(echo 13; echo 3; echo 2; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo GRM; echo 2; echo 2; echo y; echo ${PATH_PHYLOGENY}/${SAMPLE}.tree) | mpirun -np $SLURM_NTASKS HYPHYMPI
