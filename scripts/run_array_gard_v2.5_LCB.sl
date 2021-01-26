#!/bin/bash 
#SBATCH --job-name=run_gard_v2.5
#SBATCH --account=def-bacc
#SBATCH --time=0:30:0
#SBATCH --ntasks=6
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=300M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=301-638%50 #1-638

module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load hyphy/2.5.26

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/core_ALL_alignments"
PATH_GARD="/home/maeperez/scratch/Clams/hyphy2.5/gard_LCB"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"

#SAMPLE="Rmag_0001"
SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fasta//')


#cd /home/maeperez/scratch/Clams/hyphy2.5

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

echo "## GARD ##"
echo "SLURM_NTASKS =${SLURM_NTASKS}"

(echo 14; echo 1; echo "${PATH_ALN}/aligned_${SAMPLE}.fna") | mpirun -np $SLURM_NTASKS HYPHYMPI

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.best-gard ${PATH_GARD}/${SAMPLE}.best-gard
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.best-gard.fit.bf ${PATH_GARD}/${SAMPLE}.best-gard.fit.bf
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.GARD.json ${PATH_GARD}/${SAMPLE}.GARD.json
