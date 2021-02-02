#!/bin/bash 
#SBATCH --job-name=run_bucky
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=500M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 


module load StdEnv/2020


#scriptdir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/scripts/"

datadir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/core_ALL_alignments/nex"
mbdir="/home/maeperez/scratch/Clams/bucky/"

cd $mbdir
/home/maeperez/software/bucky/src/bucky -a 0.1 -n 1000 -k $SLURM_CPUS_PER_TASK -c 4 -m 5 -r 10 -o firsttry mrbayes/*.in

#rm firsttry*
#/home/maeperez/software/bucky/src/bucky -a 0.1 -n 1000000 -k $SLURM_CPUS_PER_TASK -c 4 -m 5 -r 10 --create-single-file --create-joint-file --create-sample-file --calculate-pairs -o LCB_a0.1 mrbayes/*.in