#!/bin/sh 
#SBATCH --job-name=run_KHtest
#SBATCH --account=def-bacc
#SBATCH --time=2:0:0
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=600M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=207


module load StdEnv/2018
module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_GARD="/home/maeperez/scratch/Clams/hyphy2.5/gard2"


#SAMPLE="Rmag_0001"
SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist_nopseudo_638 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"


echo " ## KH tests ## "

(echo 15; echo 2; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_GARD}/${SAMPLE}.gard_splits) | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_GARD}/${SAMPLE}.KHtest
mv ${PATH_ALN}/aligned_${SAMPLE}.fna_multi.fit ${PATH_GARD}/${SAMPLE}.multi.fit

