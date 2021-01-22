#!bin/bash

gbkpath=/home/maeperez/data/Vesic/gbk
outpath=/home/maeperez/work/mauve
ALN=ALL


/home/maeperez/software/bin/progressiveMauve --output=${outpath}/${ALN}.xmfa --output-guide-tree=${outpath}/${ALN}.tree --backbone-output=${outpath}/${ALN}.backbone ${gbkpath}/SUP05.gbk ${gbkpath}/Bathy_complete_with_CRISPRannot.gbk ${gbkpath}/R.magnifica.gbk ${gbkpath}/R.fausta.gbk ${gbkpath}/R.pacifica_one_contig_circular_fully_annotated.gbk ${gbkpath}/R.phaseoliformis_8_contigs_fully_annotated.gbk ${gbkpath}/R.pliocardia_one_contig_circular_fully_annotated.gbk ${gbkpath}/R.rectimargo_one_contig_circular_fully_annotated.gbk ${gbkpath}/R.southwardae_39_contigs_fully_annotated.gbk ${gbkpath}/V.diagonalis_one_contig_circular_fully_annotated.gbk ${gbkpath}/V.extenta_one_contig_circular_fully_annotated.gbk ${gbkpath}/V.soyoae1_one_contig_circular_fully_annotated.gbk ${gbkpath}/V.soyoae2_one_contig_circular_fully_annotated.gbk ${gbkpath}/V.gigas1_one_contig_circular_fully_annotated.gbk ${gbkpath}/V.gigas2_one_contig_circular_fully_annotated.gbk ${gbkpath}/V.okutanii.gbk ${gbkpath}/V.marissinica_withlocustags.gbk