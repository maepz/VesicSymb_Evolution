#!/bin/bash 
#SBATCH --job-name=run_array_absrel
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=300M
#SBATCH --error=%x_%A'.err' 
#SBATCH --output=%x_%A'.out' 
#SBATCH --array=2-690%50 # 1-690%50


module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14


PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna/"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_GARD="/home/maeperez/scratch/Clams/gard"
PATH_ABSREL="/home/maeperez/scratch/Clams/absrel"


GARD=$(awk -v i="$(($SLURM_ARRAY_TASK_ID))" 'FNR == i {print}' passed_gard)
SAMPLE=$(awk -F"/" '{print $NF}' passed_gard | awk -F"." '{print $1}' | awk -v i="$(($SLURM_ARRAY_TASK_ID))" 'FNR == i {print}')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

cd /home/maeperez/scratch/Clams/
mkdir absrel

echo "
## aBSREL ## 
"
# mitochondria echo 1; echo 6; echo 5;...

(echo 1; echo 6; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${GARD}; echo 1) | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_ABSREL}/${SAMPLE}.absrel

mv ${PATH_ALN}/aligned_${SAMPLE}.fna_multi.fit ${PATH_ABSREL}/${SAMPLE}.absrel.multi_fit
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.ABSREL.json ${PATH_ABSREL}/${SAMPLE}.absrel.json

#(echo 1; echo 6; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_GARD}/HKY/${SAMPLE}.HKY.gard_splits; echo 1) | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_ABSREL}/${SAMPLE}.HKY.absrel
