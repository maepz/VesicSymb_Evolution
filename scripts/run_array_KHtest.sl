#!/bin/sh 
#SBATCH --job-name=run_KHtest
#SBATCH --account=def-bacc
#SBATCH --time=0:15:0
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=200M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=1,2,7,9,11,18,19,21,23,24,26,27,29,50,51,52,55,56,57,61,63,67,71,74,80,82,85,88,92,93,94,96,97,99,100,102,103,104,105,106,107,108,109,111,112,113,115,116,117,119,120,123,124,125,127,132,133,135,137,138,139,140,144,145,147,148,153,154,158,161,164,171,172,175,176,178,179,180,184,185,187,193,195,196,209,219,221,222,226,232,233,234,238,239,253,259,263,264,269,272,275,280,283,285,286,289,292,293,294,301,303,306,308,310,312,314,327,328,332,333,334,338,339,343,382,386,401,404,415,418,434,439,443,456,495,502,507,515,525,541,542,545,549,552,554,569,589,590,599,604,616,618,623,625,629

module load StdEnv/2018
module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_GARD="/home/maeperez/scratch/Clams/hyphy2.5/gard"


#SAMPLE="Rmag_0001"
SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist_nopseudo_638 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

#cd /home/maeperez/scratch/Clams/

echo " ## KH tests ## "

(echo 15; echo 2; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_GARD}/${SAMPLE}.gard_splits) | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_GARD}/${SAMPLE}.KHtest
mv ${PATH_ALN}/aligned_${SAMPLE}.fna_multi.fit ${PATH_GARD}/${SAMPLE}.multi.fit

