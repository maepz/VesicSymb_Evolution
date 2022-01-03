#!/bin/bash
#SBATCH --job-name=run_codonbias
#SBATCH --account=def-bacc
#SBATCH --mem-per-cpu=200M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:0:0
#SBATCH --error=%x_%A_%a'.err' 
#SBATCH --output=%x_%A_%a'.out'
#SBATCH --array=1-9

PATH=$PATH:/home/maeperez/software/bin/
source ~/virtualenv/py36/bin/activate

mkdir /home/maeperez/scratch/VesicSymb_Evolution/codon_bias

PATH_GBK="/home/maeperez/VesicSymb_Evolution/genomes/additional_genomes"
PATH_CUB="/home/maeperez/scratch/VesicSymb_Evolution/codon_bias"

#SAMPLE=$(sed 's/,.*//' $PATH_ALN/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

genomefile=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $PATH_GBK/symbfiles)

SAMPLE=$(echo $genomefile | awk -F"/" '{print $NF}' | awk -F"\." '{print $1}')

echo "Starting task $SLURM_ARRAY_TASK_ID on $SAMPLE"

####### exctract CDS from genome ######

python extract_CDS_from_gbk.py -i ${genomefile} -o ${PATH_CUB}/${SAMPLE}.cds.fasta


###### run CDC ###################
#echo "CAT -i ${PATH_ALN}/aligned_${SAMPLE}.fna -c 11"
# - c 5 for mito
CAT -i ${PATH_CUB}/${SAMPLE}.cds.fasta -o ${PATH_CUB}/${SAMPLE}.cat -c 11

