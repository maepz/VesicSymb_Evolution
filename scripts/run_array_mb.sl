#!/bin/bash 
#SBATCH --job-name=run_mb
#SBATCH --account=def-bacc
#SBATCH --time=2:0:0
#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=600M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=1-195%50

module load perl
module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load intel/2020.1.217
module load mrbayes/3.2.7


#scriptdir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/scripts/"

datadir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/core_ALL_alignments/nex2"
mbdir="/home/maeperez/scratch/Clams/bucky2/mrbayes/"

#datadir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/core_ALL_alignments/nex"
#mbdir="/home/maeperez/scratch/Clams/bucky/mrbayes/"


cd $mbdir

aln=$(cat $datadir/rerun_mb_filelist | sed -n "${SLURM_ARRAY_TASK_ID}p")

#aln=$(cat $datadir/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p")

cp ${datadir}/${aln} ${aln}

SAMPLE=$(echo ${aln} | sed s'/.nex//')

nruns=10
ngen=2100000
mbsumburnin=11
mbburninfrac=0.05
samplefreq=10000
printfreq=50000
diagnfreq=500000


echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $aln"


echo "
## Run Mr.Bayes ##
"
# Create inputfile

printf "#nexus\nbegin mrbayes;\n" > input_${SAMPLE}.nex
printf "set autoclose=yes nowarn=yes;\nexecute ${aln};\n\nlset nst=6 rates=invgamma;\nprset brlenspr=Unconstrained:Exp(50.0);\n" >> input_${SAMPLE}.nex
printf "mcmc nruns=${nruns} temp=0.2 ngen=${ngen} burninfrac=${mbburninfrac} Nchains=4 " >> input_${SAMPLE}.nex
printf "samplefreq=${samplefreq} swapfreq=10 printfreq=${printfreq} " >> input_${SAMPLE}.nex
printf "mcmcdiagn=yes diagnfreq=$diagnfreq " >> input_${SAMPLE}.nex
printf "filename=${SAMPLE};\nquit;\nend;\n" >> input_${SAMPLE}.nex

# Run mcmc
(echo '') > ${SAMPLE}.nohup
mpirun -np $SLURM_NTASKS mb input_${SAMPLE}.nex >> ${SAMPLE}.nohup

# Run mbsum

mbsum -n ${mbsumburnin} -o ${SAMPLE}.in ${SAMPLE}.run*.t >> ${SAMPLE}.nohup


rm ${aln}
rm ${SAMPLE}.run*.t
rm ${SAMPLE}.run*.p
rm ${SAMPLE}.mcmc
rm ${SAMPLE}.ckp
rm ${SAMPLE}.ckp~