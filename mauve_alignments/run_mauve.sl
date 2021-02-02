#!/bin/bash 
#SBATCH --job-name=run_progressiveMauve
#SBATCH --account=def-bacc
#SBATCH --time=2:0:0
#SBATCH --mem-per-cpu=500M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mail-type=END
#SBATCH --error=%x_%A'.err' 
#SBATCH --output=%x_%A'.out' 
#SBATCH --mail-user=maepz@hotmail.com


#bash run_mauve_symbionts.sh
#bash run_mauve_mitochondria.sh
bash run_mauve_mitochondria2.sh