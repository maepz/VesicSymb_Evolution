#!/bin/bash 
#SBATCH --job-name=relax_outgroup/run_relax_V2.5_outgroup
#SBATCH --account=def-bacc
#SBATCH --time=18:0:0
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=700M
#SBATCH --error=%x_%A_%a'.err' 
#SBATCH --output=%x_%A_%a'.out' 
#SBATCH --array=2,3,4,5,9,15,16,19,24,31,39,40,41,57,58,62,64,66,72,73,76,83,86,88,96,101,102,103,107,108,114,115,116,117,119,127,129,137,138,144,145,146,147,152,165,166,167,168,169,170,173,176,189,199,200,202,210,213,225,229,231,236,238,246,247,248,249,264,267,272,274,275,280,285,287,288,303,304,314,317,321,327


module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load hyphy/2.5.26
source ~/virtualenv/py36/bin/activate


#PATH_ALN="/home/maeperez/VesicSymb_Evolution/mauve_alignments/fna"
PATH_ALN="/home/maeperez/VesicSymb_Evolution/mauve_alignments/Outgroup/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/VesicSymb_Evolution/init_trees"
PATH_RELAX="/home/maeperez/scratch/VesicSymb_Evolution/relax"

SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"


#echo " ## Label init trees ## "

#python label_tree_for_relax.py -dir $PATH_PHYLOGENY -f ${SAMPLE}.tree
python label_tree_for_relax_outgroups.py -dir $PATH_PHYLOGENY -f ${SAMPLE}.tree

echo " ## RELAX ##  "
# (echo 1; echo 7; echo 5; ...) for mito


(echo "*************************************************************"; echo ${SAMPLE}; echo "*************************************************************") > ${PATH_RELAX}/${SAMPLE}.relax

(echo "####################"; echo "GIGAS vs OUTGROUP"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax


mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsFL.RELAX.json

(echo "####################"; echo "RUTHIA vs OUTGROUP"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_RuvsFL.RELAX.json


(echo "####################"; echo "GIGAS vs RUTHIA"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 3) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsRu.RELAX.json

(echo "####################"; echo "SYMBIONTS vs OUTGROUP"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host.labeled_tree; echo 3; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_SymvsFL.RELAX.json

(echo "####################"; echo "SYMBIONTS vs SUP05"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host2.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_SymvsSUP05.RELAX.json

(echo "####################"; echo "SYMBIONTS vs putative horizontally transmitted symbionts"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host2.labeled_tree; echo 4; echo 3) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_SymvsHSym.RELAX.json

(echo "####################"; echo "SUP05 vs putative horizontally transmitted symbionts"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo 1; echo 7; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host2.labeled_tree; echo 2; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_SUP05vsHSym.RELAX.json

