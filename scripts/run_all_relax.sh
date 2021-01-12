PATH=$PATH:/Users/maeperez/Desktop/Bioinf_softwares/hyphy


#for file in ls `~/Desktop/HYPHY/GROUP1/HKY/aligned*.fna`;
for file in /Users/maeperez/Desktop/HYPHY/GROUP1/HKY/aligned_Rmag_0990.fna /Users/maeperez/Desktop/HYPHY/GROUP1/HKY/aligned_Rmag_1012.fna;
do
echo $file

SAMPLE=`echo ${file/%.fna/}`


ALIGNMENT=`echo ${SAMPLE/%.fna/}"_parsed.fna"`
#PHYLOGENY=`echo ${SAMPLE}".tree"`
#LIB=`echo $SAMPLE | cut -d'/' -f8`
TREE=`echo /Users/maeperez/Desktop/HYPHY/group1_annotated.tree`
#echo $SAMPLE
echo $ALIGNMENT
echo $TREE

cut -d'|' -f1 $file > ${SAMPLE}_parsed.fna

mpirun -np 2 HYPHYMPI /Users/maeperez/Desktop/Bioinf_softwares/hyphy/res/TemplateBatchFiles/SelectionAnalyses/RELAX.bf "Universal" ${ALIGNMENT} ${TREE} "gigas" "fl" "Minimal" > ${SAMPLE}_gigas.relax

mpirun -np 2 HYPHYMPI /Users/maeperez/Desktop/Bioinf_softwares/hyphy/res/TemplateBatchFiles/SelectionAnalyses/RELAX.bf "Universal" ${ALIGNMENT} ${TREE} "ruthia" "fl" "Minimal" > ${SAMPLE}_ruthia.relax

done
