#!/bin/bash 
#SBATCH --job-name=run_array_absrel
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=600M
#SBATCH --error=%x_%A_%a'.err' 
#SBATCH --output=%x_%A_%a'.out' 
#SBATCH --array=703-715 # 703-715


module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14


PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_ABSREL="/home/maeperez/scratch/Clams/absrel/mito"
PATH_GARD="/home/maeperez/scratch/Clams/gard/mito"


ALN=$(awk -v i="$(($SLURM_ARRAY_TASK_ID))" 'FNR == i {print}' $PATH_ALN/filelist_withpseudo)
SAMPLE=$(awk -F"/" '{print $NF}' $PATH_ALN/filelist_withpseudo | awk -F"." '{print $1}' | awk -v i="$(($SLURM_ARRAY_TASK_ID))" 'FNR == i {print}')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"


mkdir /home/maeperez/scratch/Clams/absrel/mito
cd /home/maeperez/scratch/Clams/absrel/mito

echo "
## Make simple tree ##
"

(echo 13; echo 3; echo 2; echo 1; echo ${PATH_ALN}/${SAMPLE}.fna; echo GRM; echo 2; echo 2; echo y; echo ${PATH_PHYLOGENY}/${SAMPLE}.tree) | mpirun -np 1 HYPHYMP

cp ${PATH_PHYLOGENY}/${SAMPLE}.tree ${PATH_GARD}/${SAMPLE}.GTR.gard_splits


echo "
## GARD ##
"

mkdir /home/maeperez/scratch/Clams/gard/mito
cd /home/maeperez/scratch/Clams/gard/mito

(echo "15"; echo "1"; echo "${PATH_ALN}/${SAMPLE}.fna"; echo "012345"; echo "2"; echo "4"; echo "${PATH_GARD}/${SAMPLE}.GTR.gard") | mpirun -np $SLURM_NTASKS HYPHYMPI

(echo 15; echo 2; echo ${PATH_ALN}/${SAMPLE}.fna; echo "${PATH_GARD}/${SAMPLE}.GTR.gard_splits" | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_GARD}/${SAMPLE}.KHtest
mv ${PATH_ALN}/${SAMPLE}.fna_multi.fit ${PATH_GARD}/${SAMPLE}.multi.fit


echo "
## aBSREL ## 
"
# symbiont echo 1; echo 6; echo 1;...

(echo 1; echo 6; echo 5; echo ${PATH_ALN}/${SAMPLE}.fna; echo ${PATH_GARD}/${SAMPLE}.GTR.gard_splits; echo 1) | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_ABSREL}/${SAMPLE}.absrel

mv ${PATH_ALN}/${SAMPLE}.fna_multi.fit ${PATH_ABSREL}/${SAMPLE}.absrel.multi_fit
mv ${PATH_ALN}/${SAMPLE}.fna.ABSREL.json ${PATH_ABSREL}/${SAMPLE}.absrel.json

