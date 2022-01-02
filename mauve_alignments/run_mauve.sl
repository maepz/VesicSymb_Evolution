#!/bin/bash 
#SBATCH --job-name=run_progressiveMauve
#SBATCH --account=def-bacc
#SBATCH --time=24:0:0
#SBATCH --mem-per-cpu=2G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --error=%x_%A'.err' 
#SBATCH --output=%x_%A'.out' 


#bash run_mauve_symbionts.sh
#bash run_mauve_mitochondria.sh
#bash run_mauve_mitochondria2.sh
bash run_mauve_symbionts2.sh
