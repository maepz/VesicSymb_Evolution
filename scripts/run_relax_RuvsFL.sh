#!bin/bash -l

module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load hyphy/2.5.26
source ~/virtualenv/py36/bin/activate


PATH_PHYLOGENY=$1
PATH_RELAX=$2
SAMPLE=$3
SLURM_NTASKS=$4

(echo 1; echo 7; echo ${PATH_RELAX}/${SAMPLE}_RuvsFL/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS HYPHYMPI


GivsRu
2 2

RuvsFL
3 1

GivsFL
2 1