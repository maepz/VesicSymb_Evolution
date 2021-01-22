#!/bin/bash 
#SBATCH --job-name=run_hyphy
#SBATCH --account=def-bacc
#SBATCH --time=4:0:0
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=500M
#SBATCH --error=%x_%A'.err' 
#SBATCH --output=%x_%A'.out' 
#SBATCH --array=1-669%50

module load StdEnv/2020
module load nixpkgs/16.09
module load gcc/10.2.0
module load openmpi/4.0.5


PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_GARD="/home/maeperez/scratch/Clams/hyphy2.5/gard"
PATH_ABSREL="/home/maeperez/scratch/Clams/hyphy2.5/absrel"
PATH_RELAX="/home/maeperez/scratch/Clams/hyphy2.5/relax"


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

(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.tree) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/aBSREL.bf

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.ABSREL.json ${PATH_ABSREL}/${SAMPLE}.absrel.json

echo "
## RELAX ## 
"
# (echo 1; echo 7; echo 5; ... for mito


(echo "*************************************************************"; echo ${SAMPLE}; echo "*************************************************************") > ${PATH_RELAX}/${SAMPLE}.relax

(echo "####################"; echo "GIGAS vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 2) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax


mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsFL.RELAX.json

(echo "####################"; echo "RUTHIA vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_RuvsFL.RELAX.json


(echo "####################"; echo "GIGAS vs RUTHIA"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 3) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsRu.RELAX.json

(echo "####################"; echo "SYMBIONTS vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_SymvsFL.RELAX.json

