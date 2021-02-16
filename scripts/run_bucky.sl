#!/bin/bash 
#SBATCH --job-name=run_bucky_gigas
#SBATCH --account=def-bacc
#SBATCH --time=1:0:0
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 

#module load StdEnv/2020


#scriptdir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/scripts/"

datadir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/core_ALL_alignments/nex2"
mbdir="/home/maeperez/scratch/Clams/bucky2/"
outdir="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/bucky_results"

cd $mbdir


/home/maeperez/software/bucky/src/bucky -a 0.001 -n 1000000 -k 2 -c 4 -m 5 -r 10 --create-single-file --create-joint-file --create-sample-file --calculate-pairs -o a0.001 mrbayes/*.in

/home/maeperez/software/bucky/src/bucky -a 0.001 -n 1000000 -k 2 -c 4 -m 5 -r 10 -p Ruthia.nex -o a0.001_ruthia mrbayes/*.in

/home/maeperez/software/bucky/src/bucky -a 0.001 -n 1000000 -k 2 -c 4 -m 5 -r 10 -p Gigas.nex -o a0.001_gigas mrbayes/*.in
 
cp $mbdir/*.pairs $outdir/
cp $mbdir/*.concordance $outdir/
cp $mbdir/*.input $outdir/
cp $mbdir/*.gene $outdir/