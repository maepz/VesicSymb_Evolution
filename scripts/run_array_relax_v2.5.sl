#!/bin/bash 
#SBATCH --job-name=run_relax_V2.5
#SBATCH --account=def-bacc
#SBATCH --time=2:0:0
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=800M
#SBATCH --error=%x-%A'.err' 
#SBATCH --output=%x-%A'.out' 
#SBATCH --array=7,8,11,13,14,16,17,18,19,20,24,31,33,34,37,42,43,45,50,51,52,56,57,58,59,60,65,66,67,68,69,70,71,72,73,74,75,77,79,81,86,93,98,99,100,102,104,110,111,112,113,117,120,122,123,124,125,126,128,129,133,134,135,138,139,140,141,142,143,145,146,147,151,156,157,159,160,162,163,165,166,167,168,169,170,171,172,176,180,181,186,192,193,194,196,197,201,202,203,204,205,206,207,210,212,214,215,216,217,218,219,220,227,228,229,230,232,233,235,240,242,243,244,249,251,258,259,260,261,262,264,265,266,268,271,272,280,283,288,295,297,307,311,319,325,329,334,336,337,341,343,345,348,349,352,367,369,370,371,375,376,378,381,383,384,388,389,391,392,393,396,398,400,401,403,404,405,406,407,408,409,411,412,413,414,415,416,419,420,421,422,423,424,429,434,435,438,440,443,444,450,453,458,460,466,467,468,469,472,473,474,475,476,478,479,480,484,486,489,493,494,496,497,498,500,501,505,506,507,514,519,523,524,526,527,529,531,533,537,538,539,542,543,546,548,552,553,554,555,556,557,558,559,560,565,566,567,571,572,574,575,577,580,583,589,590,591,593,597,602,604,606,607,609,612,613,615,616,617,620,622,623,628,629,630,631,632,634,635,639%50


module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
#module load hyphy/2.5.26


PATH_ALN="/home/maeperez/projects/def-bacc/maeperez/Clams/VesicSymb_Evolution/mauve_alignments/fna"
PATH_PHYLOGENY="/home/maeperez/scratch/Clams/init_trees"
PATH_RELAX="/home/maeperez/scratch/Clams/hyphy2.5/relax"

SAMPLE=$(sed 's/,.*//' ${PATH_ALN}/filelist_nopseudo_638 | sed -n "${SLURM_ARRAY_TASK_ID}p" | sed 's/aligned_//' | sed 's/.fna//')

echo "running sample # ${SLURM_ARRAY_TASK_ID}  : $SAMPLE"

cd /home/maeperez/scratch/Clams/hyphy2.5/relax

echo "
## Label init trees ##
"

#python label_tree_for_relax.py -dir $PATH_PHYLOGENY -f ${SAMPLE}.tree

echo "
## RELAX ## 
"
# (echo 1; echo 7; echo 5; ... for mito


(echo "*************************************************************"; echo ${SAMPLE}; echo "*************************************************************") > ${PATH_RELAX}/${SAMPLE}.relax

(echo "####################"; echo "GIGAS vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 2) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax


mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsFL.RELAX.json

(echo "####################"; echo "RUTHIA vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_RuvsFL.RELAX.json


(echo "####################"; echo "GIGAS vs RUTHIA"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax

(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.genera.labeled_tree; echo 3; echo 3) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_GivsRu.RELAX.json

(echo "####################"; echo "SYMBIONTS vs FREE-LIVING"; echo "####################") >> ${PATH_RELAX}/${SAMPLE}.relax


(echo ${PATH_ALN}/aligned_${SAMPLE}.fna; echo ${PATH_PHYLOGENY}/${SAMPLE}.host.labeled_tree; echo 4; echo 2) | mpirun -np $SLURM_NTASKS /home/maeperez/software/HYPHY/bin/HYPHYMPI /home/maeperez/software/HYPHY/share/hyphy/TemplateBatchFiles/SelectionAnalyses/RELAX.bf >> ${PATH_RELAX}/${SAMPLE}.relax

mv ${PATH_ALN}/aligned_${SAMPLE}.fna.RELAX.json ${PATH_RELAX}/${SAMPLE}_SymvsFL.RELAX.json

