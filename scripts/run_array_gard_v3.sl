#!/bin/bash 
#SBATCH --job-name=run_array_gard2
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=300M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=5,7,13,17,21,41,43,44,45,56,61,66,68,73,75,76,77,78,80,81


module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_GARD="/home/maeperez/scratch/Clams/gard"


#SAMPLE="Rmag_0001"
SAMPLE=$(sed 's/,.*//' failed_gard_GTR2 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')


cd /home/maeperez/scratch/Clams/

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

echo "
## GARD ##
"
echo "SLURM_NTASKS =${SLURM_NTASKS}"
echo " run GTR... "


(echo "${PATH_ALN}/aligned_${SAMPLE}.fna"; echo "012345"; echo "2"; echo "4"; echo "${PATH_GARD}/GTR/${SAMPLE}.GTR.gard") | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/bin/GARD.bf

#(echo "${PATH_ALN}/aligned_${SAMPLE}.fna"; echo "012345"; echo "2"; echo "2"; echo "${PATH_GARD}/GTR/${SAMPLE}.GTR.gard") | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/bin/GARD.bf

#(echo "15"; echo "1"; echo "${PATH_ALN}/aligned_${SAMPLE}.fna"; echo "012345"; echo "2"; echo "2"; echo "${PATH_GARD}/GTR/${SAMPLE}.GTR.gard") | mpirun -np $SLURM_NTASKS HYPHYMPI

#echo "run HKY ..."

#(echo "${PATH_ALN}/aligned_${SAMPLE}.fna"; echo "010010"; echo "2"; echo "4"; echo "${PATH_GARD}/GTR/${SAMPLE}.HKY.gard") | mpirun -np $SLURM_NTASKS HYPHYMPI /home/maeperez/software/bin/GARD.bf

#(echo "15"; echo "1"; echo "${PATH_ALN}/aligned_${SAMPLE}.fna"; echo "010010"; echo "2"; #echo "4"; echo "${PATH_GARD}/HKY/${SAMPLE}.HKY.gard") | mpirun -np $SLURM_NTASKS HYPHYMPI

