#bin/bash!

PATH=$PATH:/Users/maeperez/Desktop/Bioinf_softwares/bucky/src

ls genes/nex/ > genes_files.txt
perl mb_analysis_genes.pl geneRowNb=1 Ngenes=795 fullrun #len(file)

bucky -n 1000 -o firsttry genes/*.in
rm firsttry*
mkdir genes/bca

bucky -n 100000 -c 2 -o genes/bca/a1 genes/*.in