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
aln="aligned_Rmag_0178_1_0to303.nex"

nruns=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=1 'FNR == i {print $j}' $file)
ngen=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=2 'FNR == i {print $j}' $file)
samplefreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=3 'FNR == i {print $j}' $file)
mbsumburnin=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=4 'FNR == i {print $j}' $file)
mbburninfrac=$(echo "scale=7;$(($mbsumburnin))/$(($ngen))" | bc)
printfreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=5 'FNR == i {print $j}' $file)
diagnfreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=6 'FNR == i {print $j}' $file)

cd $mbdir

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

echo "
## Run Mr.Bayes ##
"
# Create inputfile

printf "#nexus\nbegin mrbayes;\n" > input_${SLURM_ARRAY_TASK_ID}.nex
printf "set autoclose=yes nowarn=yes;\nexecute ${datadir}${aln};\n\nlset nst=6 rates=invgamma;\nprset brlenspr=Unconstrained:Exp(50.0);\n" >> input_${SLURM_ARRAY_TASK_ID}.nex
printf "mcmc nruns=${nruns} temp=0.2 ngen=${ngen} burninfrac=${mbburninfrac} Nchains=4 " >> input_${SLURM_ARRAY_TASK_ID}.nex
printf "samplefreq=${samplefreq} swapfreq=10 printfreq=${printfreq} " >> input_${SLURM_ARRAY_TASK_ID}.nex
printf "mcmcdiagn=yes diagnfreq=$diagnfreq " >> input_${SLURM_ARRAY_TASK_ID}.nex
printf "filename=input_${SLURM_ARRAY_TASK_ID};\nquit;\nend;\n" >> input_${SLURM_ARRAY_TASK_ID}.nex

# Run mcmc

mpirun -np $SLURM_NTASKS mb input_${SLURM_ARRAY_TASK_ID}.nex >> params_${SLURM_ARRAY_TASK_ID}.nohup

# Run mbsum

mbsum -n ${mbsumburnin} -o params_${SLURM_ARRAY_TASK_ID}.in params_${SLURM_ARRAY_TASK_ID}.run?.t >> params_${SLURM_ARRAY_TASK_ID}.nohup
