#!/bin/bash 
#SBATCH --job-name=run_array_gard2
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=100M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=1-800

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
## Run Mr.Bayes and mbsum ##
"
perl mb_analysis_genes.pl $datadir $fileOfFilenames $mbdir geneRowNb=1 Ngenes=1 ngen=${ngen} samplefreq=${samplefreq) mbsumburnin={mbsumburnin} nruns=$SLURM_NTASKS #len(file)


