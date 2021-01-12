PATH=$PATH:/Users/maeperez/Desktop/Bioinf_softwares/hyphy


#for file in ls ~/Desktop/HYPHY/Bathy_methyl/aligned*.fna;
for file in /Users/maeperez/Desktop/HYPHY/GROUP1/aligned_Rmag_0609.fna /Users/maeperez/Desktop/HYPHY/GROUP1/aligned_Rmag_0320.fna;
do
echo $file

SAMPLE=`echo ${file/%.fna/}`

ALIGNMENT=`echo ${SAMPLE/%.fna/}".fna"`
PHYLOGENY=`echo ${SAMPLE}".tree"`
LIB=`echo $SAMPLE | cut -d'/' -f7`
#echo $SAMPLE
echo $LIB

HYPHYMP /Users/maeperez/Desktop/HYPHY/TemplaBUSTED-SRV.bf
HYPHYMP /Users/maeperez/Desktop/HYPHY/TemplateModels/NeighborJoining.bf "Full likelihood" "Nucleotide/Protein" ${ALIGNMENT} "GRM" "Global" "Force Zero" "y" ${PHYLOGENY} "" "y"

### does not work with GRT ("012345") model on all alignments ###
mpirun -np 2 HYPHYMPI /Users/maeperez/Desktop/HYPHY/TemplateModels/GARD.bf ${ALIGNMENT} "012345" "General Discrete" "4" ${SAMPLE}.GTR.gard

mpirun -np 2 HYPHYMPI /Users/maeperez/Desktop/HYPHY/TemplateModels/GardProcessor.bf ${ALIGNMENT} ${SAMPLE}.GTR.gard_splits > ${SAMPLE}.GTR.HKtest

### could not make this work ####
#HYPHYMP /Users/maeperez/Desktop/HYPHY/TemplateModels/mae2_MEME_mf.bf "Universal" "New Analysis" "Default" "1" ${ALIGNMENT} ${SAMPLE}.GTR.gard_splits test_results/${SAMPLE}.MEME "0.05" ${SAMPLE}.MEME.csv

#HYPHYMP /Users/maeperez/Desktop/HYPHY/TemplateModels/mae2_MEME_mf.bf "Universal" "New Analysis" "Default" "1" ${ALIGNMENT} ${SAMPLE}.GTR.gard_splits test_results/${SAMPLE}.MEME "0.05" ${SAMPLE}.MEME.csv

#HYPHYMP /Users/maeperez/Desktop/HYPHY/TemplateModels/MEME_mf.bf "Universal" "New Analysis" "Default" "1" ${ALIGNMENT} ${SAMPLE}.GTR.gard_splits test_results/${SAMPLE}.MEME "0.05" ${SAMPLE}.MEME.csv

#HYPHYMP /Users/maeperez/Desktop/HYPHY/TemplateModels/mae_MEME_mf.bf "Universal" "New Analysis" "Default" "1" ${ALIGNMENT} ${SAMPLE}.GTR.gard_splits test_results/${SAMPLE}.MEME "0.05" ${SAMPLE}.MEME.csv

### could not make this work ####
#mpirun -np 2 HYPHYMPI /Users/maeperez/Desktop/HYPHY/TemplateModels/MEME_mf.bf "Universal" "New Analysis" "Default" "1" ${ALIGNMENT} ${PHYLOGENY} test_results/${SAMPLE}.MEME "0.05" $test_results/{SAMPLE}.MEME.csv


mpirun -np 2 HYPHYMPI /Users/maeperez/Desktop/HYPHY/TemplateModels/mae_BranchSiteREL.bf "Universal" "Yes" "No" ${ALIGNMENT} ${SAMPLE}.GTR.gard_splits "All" "" ${SAMPLE}.bsrel

done
