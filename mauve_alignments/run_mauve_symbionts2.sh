#!bin/bash

gbkpath=/home/maeperez/VesicSymb_Evolution/genomes
outpath=/home/maeperez/scratch/VesicSymb_Evolution/mauve
outgroupgbkpath=/home/maeperez/VesicSymb_Evolution/genomes/additional_genomes

ALN=OUTGROUP

cd $outpath

/home/maeperez/software/bin/progressiveMauve --output=${outpath}/${ALN}.xmfa --output-guide-tree=${outpath}/${ALN}.tree --backbone-output=${outpath}/${ALN}.backbone \
SUP05.gbk \
R.magnifica.gbk \
Bathy_complete_with_CRISPRannot.gbk \
Bathysepcomplete_AP013042.gbk \
Bathyther_MIQH01.gbk \
Bathy2_CAEB01.gbk \
Bathyazo_CAESAP02.gbk \
Sponge_JYIN01.gbk \
ThioNP1complete_CP023860.gbk \
ThiosingularisPS1complete_CP006911.gbk \
Thioautotrophicus_DQLA01.gbk \
Thioperditus_PNQY01.gbk \
Thiopontius_JACNGB01.gbk \
ThioTMED218_NHJP01.gbk \


