#!/bin/bash 
#SBATCH --job-name=run_array_build_init_tree
#SBATCH --account=def-bacc
#SBATCH --time=0:10:0
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=500M
#SBATCH --error=%A'.err' 
#SBATCH --output=%A'.out' 
#SBATCH --array=11-702%50 

module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14

cd /home/maeperez/scratch/Clams/
mkdir init_trees

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_GARD="/home/maeperez/scratch/Clams/gard"
PATH_ABSREL="/home/maeperez/scratch/Clams/absrel"


#SAMPLE="Rmag_0001"
SAMPLE=$(sed 's/,.*//' $PATH_ALN/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"


echo "
## build inital tree ##
"
 #### NOT WORKING YET ####

(echo 12; echo 3; echo 2; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo "GRM"; echo 3; echo 5; echo 4) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI >> tree

12 3 2 1 {fna} GRM 3 5 4 