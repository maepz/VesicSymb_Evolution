#!/bin/bash 
#SBATCH --job-name=run_relax
#SBATCH --account=def-bacc
#SBATCH --time=6:0:0
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=200M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=45,146,154,160,187,216,241,275,338,366,444,460,479,620

module unload StdEnv/2020
module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14
#source ~/virtualenv/py36/bin/activate

mkdir /home/maeperez/scratch/Clams/relax

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_RELAX="/home/maeperez/scratch/Clams/relax"

SAMPLE=$(sed 's/,.*//' $PATH_ALN/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

echo "
## Label init trees ##
"

#python label_tree_for_relax.py -dir $PATH_PHYLOGENY -f ${SAMPLE}.tree

cd /home/maeperez/scratch/Clams/relax

echo "
## RELAX ## 
"
# (echo 1; echo 7; echo 5; ... for mito


(echo "*************************************************************"; echo ${SAMPLE}; echo "*************************************************************") > ${PATH_RELAX}/${SAMPLE}.relax

(echo "####################"; echo "GIGAS vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

#(echo 1; echo 7; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

#(echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/bin/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

(echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/hyphy/res/TemplateBatchFiles/SelectionAnalyses >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsFL.RELAX.json

(echo "####################"; echo "RUTHIA vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

#(echo 1; echo 7; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 4; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

#(echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 4; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/bin/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

(echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 4; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/hyphy/res/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_RuvsFL.RELAX.json


(echo "####################"; echo "GIGAS vs RUTHIA"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

#(echo 1; echo 7; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 3; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

#(echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 3; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/bin/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

(echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 3; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/hyphy/res/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsRu.RELAX.json

(echo "####################"; echo "SYMBIONTS vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

#(echo 1; echo 7; echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host.labeled_tree; echo 4; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

#(echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host.labeled_tree; echo 4; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/bin/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

(echo 1; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host.labeled_tree; echo 4; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/hyphy/res/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_SymvsFL.RELAX.json

