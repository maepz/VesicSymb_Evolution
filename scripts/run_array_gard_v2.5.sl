#!/bin/bash 
#SBATCH --job-name=run_gard_v2.5
#SBATCH --account=def-bacc
#SBATCH --time=6:0:0
#SBATCH --ntasks=12
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=100M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=240,276,570 #1-638

module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load hyphy/2.5.26
source /home/maeperez/virtualenv/py36/bin/activate

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_GARD="/home/maeperez/scratch/Clams/hyphy2.5/gard2"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"

SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist_nopseudo_638 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

echo "## GARD ##"
echo "SLURM_NTASKS =${SLURM_NTASKS}"

#(echo 14; echo 1; echo "${PATH_ALN}/aligned_${SAMPLE}.fna") | mpirun -np $SLURM_NTASKS HYPHYMPI --> --rv None rate class ok, model ok

mpirun -np $SLURM_NTASKS HYPHYMPI gard --alignment ${PATH_ALN}/aligned_${SAMPLE}.fna --rv Gamma --rate-classes 4 --model GTR

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.best-gard ${PATH_GARD}/${SAMPLE}.best-gard
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.best-gard.fit.bf ${PATH_GARD}/${SAMPLE}.best-gard.fit.bf
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.GARD.json ${PATH_GARD}/${SAMPLE}.GARD.json

echo " Get gard_splits tree"

python get_gardsplits_file.py -i $PATH_GARD/${SAMPLE}.GARD.json -out $PATH_GARD

echo " run the KH test"

module load StdEnv/2018
module load nixpkgs/16.09
module load gcc/7.3.0
module load openmpi/3.1.4
module load hyphy/2.3.14

(echo 15; echo 2; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_GARD}/${SAMPLE}.gard_splits) | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_GARD}/${SAMPLE}.KHtest
mv ${PATH_ALN}/aligned_${SAMPLE}.fna_multi.fit ${PATH_GARD}/${SAMPLE}.multi.fit

