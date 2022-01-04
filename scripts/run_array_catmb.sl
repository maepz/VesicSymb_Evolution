#!/bin/bash 
#SBATCH --job-name=run_catmb
#SBATCH --account=def-bacc
#SBATCH --time=24:0:0
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=1G
#SBATCH --error=%x-%A_%a'.err' 
#SBATCH --output=%x-%A_%a'.out' 
#SBATCH --array=6

module load perl
module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load intel/2020.1.217
module load mrbayes/3.2.7
source /home/maeperez/virtualenv/py36/bin/activate

#scriptdir="/home/maeperez/VesicSymb_Evolution/scripts/"

datadir="/home/maeperez/VesicSymb_Evolution/mauve_alignments/cat_alignments/"
mbdir="/home/maeperez/scratch/VesicSymb_Evolution/mrbayes_CAT/"


cd $mbdir


aln=$(cat $datadir/filelist | sed -n "${SLURM_ARRAY_TASK_ID}p")
SAMPLE=$(echo ${aln} | sed s'/.fna//')

python -c "from Bio import SeqIO;from Bio.Alphabet import generic_dna;SeqIO.convert('${datadir}${aln}','fasta','${mbdir}${SAMPLE}.fna','nexus',generic_dna)"



nruns=10
ngen=2100000
mbsumburnin=11
mbburninfrac=0.05
samplefreq=10000
printfreq=50000
diagnfreq=500000


echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"


echo "
## Run Mr.Bayes ##
"
# Create i	

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
/home/maeperez/software/bin/mbsum -n ${mbsumburnin} -o ${SAMPLE}.in ${SAMPLE}.run*.t >> ${SAMPLE}.nohup

