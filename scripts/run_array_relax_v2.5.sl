#!/bin/bash 
#SBATCH --job-name=run_relax_V2.5
#SBATCH --account=def-bacc
#SBATCH --time=6:0:0
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --mem-per-cpu=500M
#SBATCH --error=%x-%A_%a'.err' 
#SBATCH --output=%x-%A_%a'.out' 
#SBATCH --array=533


module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load hyphy/2.5.26
#source ~/virtualenv/py36/bin/activate


PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_RELAX="/home/maeperez/scratch/Clams/hyphy2.5/relax"

SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist_nopseudo_638 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

#cd /home/maeperez/scratch/Clams/hyphy2.5/relax

#echo " ## Label init trees ## "

#python label_tree_for_relax.py -dir $PATH_PHYLOGENY -f ${SAMPLE}.tree

echo " ## RELAX ##  "
# (echo 1; echo 7; echo 5; ... for mito


(echo "*************************************************************"; echo ${SAMPLE}; echo "*************************************************************") > ${PATH_RELAX}/${SAMPLE}.relax

(echo "####################"; echo "GIGAS vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax


mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsFL.RELAX.json

(echo "####################"; echo "RUTHIA vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_RuvsFL.RELAX.json


(echo "####################"; echo "GIGAS vs RUTHIA"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 3) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsRu.RELAX.json

(echo "####################"; echo "SYMBIONTS vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_SymvsFL.RELAX.json

