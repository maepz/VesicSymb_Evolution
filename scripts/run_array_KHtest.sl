#!/bin/sh 
#SBATCH --job-name=run_array_KHtest
#SBATCH --account=def-bacc
#SBATCH --time=6:00:0
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=150M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=580

module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
#PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_GARD="/home/maeperez/scratch/Clams/gard"
#PATH_ABSREL="/home/maeperez/scratch/Clams/absrel"


#SAMPLE="Rmag_0001"
GARD=$(awk -v i="$(($SLURM_ARRAY_TASK_ID))" 'FNR == i {print}' passed_gard)
SAMPLE=$(awk -F"/" '{print $NF}' passed_gard | awk -F"." '{print $1}' | awk -v i="$(($SLURM_ARRAY_TASK_ID))" 'FNR == i {print}')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

cd /home/maeperez/scratch/Clams/

echo "
## KH tests ## 
"

(echo 15; echo 2; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${GARD}) | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_GARD}/GTR/${SAMPLE}.KHtest
mv ${PATH_ALN}/aligned_${SAMPLE}.fna_multi.fit ${PATH_GARD}/GTR/${SAMPLE}.multi.fit

