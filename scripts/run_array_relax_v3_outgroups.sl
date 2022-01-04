#!/bin/bash 
#SBATCH --job-name=relax_outgroup/run_relax_V3_outgroup
#SBATCH --account=def-bacc
#SBATCH --time=6:00:0
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=300M
#SBATCH --error=%x_%A_%a'.err' 
#SBATCH --output=%x_%A_%a'.out' 
#SBATCH --array=1-13


module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load hyphy/2.5.26
source ~/virtualenv/py36/bin/activate


#PATH_ALN="/home/maeperez/VesicSymb_Evolution/mauve_alignments/fna"
PATH_ALN="/home/maeperez/VesicSymb_Evolution/mauve_alignments/Outgroup/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/VesicSymb_Evolution/init_trees"
PATH_RELAX="/home/maeperez/scratch/VesicSymb_Evolution/relax"

file=failed_relax

SAMPLE=$(awk -F"\t" -v i="$(($SLURM_ARRAY_TASK_ID))" -v j=1 'FNR == i {print $j}' $file)
COMP=$(awk -F"\t" -v i="$(($SLURM_ARRAY_TASK_ID))" -v j=2 'FNR == i {print $j}' $file)

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE, $COMP"


#echo " ## Label init trees ## "

#python label_tree_for_relax.py -dir $PATH_PHYLOGENY -f ${SAMPLE}.tree
#python label_tree_for_relax_outgroups.py -dir $PATH_PHYLOGENY -f ${SAMPLE}.tree

#echo " ## RELAX ##  "

#### create dir structure
mkdir ${PATH_RELAX}/${SAMPLE}_${COMP}
cp ${PATH_ALN}/aligned_${SAMPLE}.fna ${PATH_RELAX}/${SAMPLE}_${COMP}/aligned_${SAMPLE}.fna

echo ${PATH_RELAX}/${SAMPLE}_RuvsFL/aligned_${SAMPLE}.fna
echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree
#### run relax 

bash run_relax_${COMP}.sh $PATH_PHYLOGENY $PATH_RELAX $SAMPLE $SLURM_NTASKS

#### Clean up

mv ${PATH_RELAX}/${SAMPLE}_${COMP}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_${COMP}.RELAX.json

rm -r ${PATH_RELAX}/${SAMPLE}_${COMP}









