#bin/bash!

PATH=$PATH:/home/mp2c18/software/bucky/src # path to bucky
PATH=$PATH:/home/mp2c18/software/MrBayes/bin # path to MrBayes

DATPATH=/home/mp2c18/data/bucky/Genes

ls `echo ${DATPATH}/nex/` > $DATPATH/genes_files.txt
perl mb_analysis_genes.pl geneRowNb=1 Ngenes=793 fullrun #len(file)
