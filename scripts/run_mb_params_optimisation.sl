#!/bin/bash 
#SBATCH --job-name=run_mb_params_optimisation
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=500M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=1-6 #1-6

module load perl
module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load intel/2020.1.217
module load mrbayes/3.2.7


aln="LCB_001_3_684to1390"
#aln="LCB_124_1_0to186.nex"


#scriptdir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/scripts/"
datadir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/core_ALL_alignments/nex/"
fileOfFilenames="mrbayes_params.filelist"
mbdir="/home/maeperez/scratch/Clams/bucky/mrbayes/optimization/"

file=mrbayes_params
SAMPLE=$(echo ${aln} | sed s'/.nex//')

mkdir $mbdir$SAMPLE
cd $mbdir
cp ${datadir}${aln} $SAMPLE/${aln}


nruns=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=1 'FNR == i {print $j}' $file)
ngen=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=2 'FNR == i {print $j}' $file)
samplefreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=3 'FNR == i {print $j}' $file)
mbsumburnin=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=4 'FNR == i {print $j}' $file)
#mbburninfrac=$(echo "scale=7;$(($mbsumburnin))/$(($ngen))" | bc)
mbburninfrac=0.01
printfreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=5 'FNR == i {print $j}' $file)
diagnfreq=$(awk -F"," -v i="$(($SLURM_ARRAY_TASK_ID+1))" -v j=6 'FNR == i {print $j}' $file)


echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $aln"

cd $SAMPLE

echo "
## Run Mr.Bayes ##
"
# Create inputfile

printf "#nexus\nbegin mrbayes;\n" > params_${SLURM_ARRAY_TASK_ID}.nex
printf "set autoclose=yes nowarn=yes;\nexecute ${aln};\n\nlset nst=6 rates=invgamma;\nprset brlenspr=Unconstrained:Exp(50.0);\n" >> params_${SLURM_ARRAY_TASK_ID}.nex
printf "mcmc nruns=${nruns} temp=0.2 ngen=${ngen} burninfrac=${mbburninfrac} Nchains=4 " >> params_${SLURM_ARRAY_TASK_ID}.nex
printf "samplefreq=${samplefreq} swapfreq=10 printfreq=${printfreq} " >> params_${SLURM_ARRAY_TASK_ID}.nex
printf "mcmcdiagn=yes diagnfreq=$diagnfreq " >> params_${SLURM_ARRAY_TASK_ID}.nex
printf "filename=params_${SLURM_ARRAY_TASK_ID};\nquit;\nend;\n" >> params_${SLURM_ARRAY_TASK_ID}.nex

# Run mcmc
(echo '') > params_${SLURM_ARRAY_TASK_ID}.nohup
mpirun -np $SLURM_NTASKS mb params_${SLURM_ARRAY_TASK_ID}.nex >> params_${SLURM_ARRAY_TASK_ID}.nohup

# Run mbsum

mbsum -n ${mbsumburnin} -o params_${SLURM_ARRAY_TASK_ID}.in params_${SLURM_ARRAY_TASK_ID}.run?.t >> params_${SLURM_ARRAY_TASK_ID}.nohup
