#!/bin/bash 
#SBATCH --job-name=run_mito_absrel
#SBATCH --account=def-bacc
#SBATCH --time=6:0:0
#SBATCH --ntasks=6
#SBATCH --mem-per-cpu=300M
#SBATCH --error=%x_%A'.err' 
#SBATCH --output=%x_%A'.out' 
#SBATCH --array=4-9,11,13,14 # 1-13

module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load hyphy/2.5.26
source /home/maeperez/virtualenv/py36/bin/activate

MITO_DATASET=MITO_Mlamarckii
#mkdir /home/maeperez/scratch/Clams/hyphy2.5/${MITO_DATASET}

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/Mitochondria/${MITO_DATASET}/Codon_aln"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/hyphy2.5/${MITO_DATASET}"
PATH_GARD="/home/maeperez/scratch/Clams/hyphy2.5/${MITO_DATASET}"
PATH_ABSREL="/home/maeperez/scratch/Clams/hyphy2.5/${MITO_DATASET}"


SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

#cd /home/maeperez/scratch/Clams/hyphy2.5/

echo "
## GARD ##
"
echo "SLURM_NTASKS =${SLURM_NTASKS}"


#(echo 14; echo 1; echo "${PATH_ALN}/${SAMPLE}.fna") | mpirun -np $SLURM_NTASKS HYPHYMPI

mpirun -np $SLURM_NTASKS HYPHYMPI gard --alignment ${PATH_ALN}/${SAMPLE}.fna --rv Gamma --rate-classes 4 --model GTR

mv ${PATH_ALN}/${SAMPLE}.fna.best-gard $PATH_GARD/${SAMPLE}.best-gard
mv ${PATH_ALN}/${SAMPLE}.fna.best-gard.fit.bf $PATH_GARD/${SAMPLE}.best-gard.fit.bf
mv ${PATH_ALN}/${SAMPLE}.fna.GARD.json $PATH_GARD/${SAMPLE}.GARD.json

echo " Get gard_splits tree"

python get_gardsplits_file.py -i $PATH_GARD/${SAMPLE}.GARD.json -out $PATH_GARD

echo "
## aBSREL ## 
"

mpirun -np $SLURM_NTASKS HYPHYMPI absrel --code Invertebrate-mtDNA --alignment ${PATH_ALN}/${SAMPLE}.fna --tree $PATH_GARD/${SAMPLE}.gard_splits


mv ${PATH_ALN}/${SAMPLE}.fna.ABSREL.json ${PATH_ABSREL}/${SAMPLE}.absrel.json
