#!bin/bash

gbkpath=/home/maeperez/data/Vesic/gbk
outpath=/home/maeperez/work/mauve
ALN=MITO


/home/maeperez/software/bin/progressiveMauve --output=${outpath}/${ALN}.xmfa --output-guide-tree=${outpath}/${ALN}.tree --backbone-output=${outpath}/${ALN}.backbone ${gbkpath}/A.diagonalis.gbk ${gbkpath}/A.gigas1.gbk ${gbkpath}/A.gigas2.gbk ${gbkpath}/A.mariana_ref.gbk ${gbkpath}/A.phaseoliformis.gbk ${gbkpath}/A.phaseoliformis_ref.gbk ${gbkpath}/A.southwardae.gbk ${gbkpath}/C.magnifica.gbk ${gbkpath}/C.pacifica.gbk ${gbkpath}/C.rectimargo.gbk ${gbkpath}/MK948426.gbk ${gbkpath}/MT528632.1.gbk ${gbkpath}/P.extenta.gbk ${gbkpath}/P.okutanii_ref.gbk ${gbkpath}/P.soyoae1.gbk ${gbkpath}/P.soyoae2.gbk ${gbkpath}/X.pliocardia.gbk