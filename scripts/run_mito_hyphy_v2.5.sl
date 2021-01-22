#!/bin/bash 
#SBATCH --job-name=run_array_absrel
#SBATCH --account=def-bacc
#SBATCH --time=2:0:0
#SBATCH --ntasks=6
#SBATCH --mem-per-cpu=800M
#SBATCH --error=%x_%A'.err' 
#SBATCH --output=%x_%A'.out' 
#SBATCH --array=1 # 1-669%50

module load StdEnv/2020
module load nixpkgs/16.09
module load gcc/10.2.0
module load openmpi/4.0.5


PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_GARD="/home/maeperez/scratch/Clams/hyphy2.5/gard"
PATH_ABSREL="/home/maeperez/scratch/Clams/hyphy2.5/absrel"


SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist_nopseudo_669 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

cd /home/maeperez/scratch/Clams/hyphy2.5/

echo "
## GARD ##
"
echo "SLURM_NTASKS =${SLURM_NTASKS}"
echo " move NJ tree to gard GTR... "


(echo "${PATH_ALN}/aligned_${SAMPLE}.fna") | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/GARD.bf

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.best-gard $PATH_GARD/${SAMPLE}.best-gard
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.best-gard.fit.bf $PATH_GARD/${SAMPLE}.best-gard.fit.bf
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.GARD.json $PATH_GARD/${SAMPLE}.GARD.json

echo "
## aBSREL ## 
"

(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_GARD}/${SAMPLE}.best-gard) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/aBSREL.bf

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.ABSREL.json ${PATH_ABSREL}/${SAMPLE}.absrel.json
