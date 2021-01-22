#!/bin/bash 
#SBATCH --job-name=run_gard_v2.5
#SBATCH --account=def-bacc
#SBATCH --time=6:0:0
#SBATCH --ntasks=12
#SBATCH --mem-per-cpu=300M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=44 #2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,27,28,29,30,31,32,33,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,79,81,84,86,98,99,100,102,104,109,110,112,113,117,120,123,124,125,126,128,133,134,135,137,138,139,140,141,142,143,144,145,146,147,149,150,151,152,156,157,159,160,162,163,165,166,167,168,169,170,171,172,181,184,192,193,194,195,196,197,201,202,204,205,206,207,208,210,212,214,215,216,217,218,219,220,224,227,228,229,230,232,233,240,242,244,251,258,259,261,262,264,266,268,271,272,297,317,329,334,337,341,343,344,345,348,349,352,367,369,370,371,375,376,378,381,383,388,391,392,396,398,400,401,403,404,405,406,407,408,409,411,412,413,414,415,417,419,420,421,422,423,424,429,434,438,440,443,450,453,466,467,472,473,474,475,476,478,479,484,486,489,494,496,497,498,500,501,505,506,507,519,523,526,527,529,531,533,537,539,543,546,548,552,553,554,556,557,558,559,560,567,571,572,575,577,580,583,588,589,590,592,596,601,603,605,606,611,612,614,616,619,621,622,629,630,631%50

module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
#module load hyphy/2.5.26

PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_GARD="/home/maeperez/scratch/Clams/hyphy2.5/gard"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"

#SAMPLE="Rmag_0001"
SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist_nopseudo_638 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')


cd /home/maeperez/scratch/Clams/hyphy2.5

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

echo "
## GARD ##
"
echo "SLURM_NTASKS =${SLURM_NTASKS}"
echo " move NJ tree to gard GTR... "


(echo "${PATH_ALN}/aligned_${SAMPLE}.fna") | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/GARD.bf

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.best-gard $PATH_GARD/${SAMPLE}.best-gard
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.best-gard.fit.bf $PATH_GARD/${SAMPLE}.best-gard.fit.bf
mv ${PATH_ALN}/aligned_${SAMPLE}.fna.GARD.json $PATH_GARD/${SAMPLE}.GARD.json

echo "
## KH test ##
"

# the new version doesnt lineup nicely with gard output... will try older version
(echo 1; echo "${PATH_ALN}/aligned_${SAMPLE}.fna"; echo 2; echo "GRM"; echo 3; echo 5; echo 4; echo "${PATH_TREE}/${SAMPLE}.tree" | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/KHTest.bf

#(echo 15; echo 2; echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${GARD}) | mpirun -np $SLURM_NTASKS HYPHYMPI > ${PATH_GARD}/${SAMPLE}.KHtest


