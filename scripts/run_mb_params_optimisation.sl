#!/bin/bash 
#SBATCH --job-name=run_mb_params_optimisation
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=500M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=1 #1-5

module load perl
module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load intel/2020.1.217
module load mrbayes/3.2.7

datadir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/non_recomb_fna/"
fileOfFilenames="mrbayes_params.filelist"
mbdir="/home/maeperez/scratch/Clams/bucky/mrbayes/optimization/"

file=mrbayes_params

nruns=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=1 'FNR == i {print $j}' $file)
ngen=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=2 'FNR == i {print $j}' $file)
samplefreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=3 'FNR == i {print $j}' $file)
mbsumburnin=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=4 'FNR == i {print $j}' $file)
printfreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=5 'FNR == i {print $j}' $file)
diagnfreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=6 'FNR == i {print $j}' $file)

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

echo "
## Run Mr.Bayes and mbsum ##
"

echo "perl /home/maeperez/software/bin/mb_analysis_genes.pl datadir=${datadir} fileOfFilenames=${fileOfFilenames} mbdir=${mbdir} geneRowNb=1 Ngenes=1 nruns=${SLURM_NTASKS} ngen=${ngen} samplefreq=${samplefreq} mbsumburnin=${mbsumburnin} printfreq=${printfreq} diagnfreq=${diagnfreq}"


perl /home/maeperez/software/bin/mb_analysis_genes.pl datadir=${datadir} fileOfFilenames=${fileOfFilenames} mbdir=${mbdir} geneRowNb=1 Ngenes=1 nruns=$SLURM_NTASKS ngen=${ngen} samplefreq=${samplefreq} mbsumburnin=${mbsumburnin} printfreq=${printfreq} diagnfreq=${diagnfreq}

