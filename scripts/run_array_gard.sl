#!/bin/bash 
#SBATCH --job-name=run_array_gard
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=1G
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=1


module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14

cd /home/maeperez/scratch/Clams/
mkdir gard
mkdir gard/GTR
mkdir gard/HKY


PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_GARD="/home/maeperez/scratch/Clams/gard"


#SAMPLE="Rmag_0001"
SAMPLE=$(sed 's/,.*//' $PATH_ALN/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

echo "
## GARD ##
"
echo "SLURM_NTASKS =${SLURM_NTASKS}"
echo " run GTR... 
"

(echo "15"; echo "1"; echo "${PATH_ALN}/aligned_${SAMPLE}.fna"; echo "012345"; echo "2"; echo "4"; echo "${PATH_GARD}/GTR/${SAMPLE}.GTR.gard") | mpirun -np $SLURM_NTASKS HYPHYMPI

#echo "run HKY ...
"

#(echo "15"; echo "1"; echo "${PATH_ALN}/aligned_${SAMPLE}.fna"; echo "010010"; echo "2"; echo "4"; echo "${PATH_GARD}/HKY/${SAMPLE}.HKY.gard") | mpirun -np $SLURM_NTASKS HYPHYMPI

