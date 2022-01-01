#!bin/bash

gbkpath=/home/maeperez/VesicSymb_Evolution/genomes
outpath=/home/maeperez/work/mauve
outgroupgbkpath=/home/maeperez/VesicSymb_Evolution/genomes/additional_genomes

ALN=OUTGROUP


/home/maeperez/software/bin/progressiveMauve --output=${outpath}/${ALN}.xmfa --output-guide-tree=${outpath}/${ALN}.tree --backbone-output=${outpath}/${ALN}.backbone \
${gbkpath}/SUP05.gbk \
${gbkpath}/Bathy_complete_with_CRISPRannot.gbk \
${gbkpath}/R.magnifica.gbk \
${outgroupgbkpath}/Bathy2_CAEB01.gbk \
${outgroupgbkpath}/Bathyazo_CAESAP02.gbk \
${outgroupgbkpath}/Bathysepcomplete_AP013042.gbk \
${outgroupgbkpath}/Bathyther_MIQH01.gbk Sponge_JYIN01.gbk \
${outgroupgbkpath}/Thioautotrophicus_DQLA01.gbk \
${outgroupgbkpath}/ThioNP1complete_CP023860.gbk \
${outgroupgbkpath}/Thioperditus_PNQY01.gbk \
${outgroupgbkpath}/Thiopontius_JACNGB01.gbk \
${outgroupgbkpath}/ThiosingularisPS1complete_CP006911.gbk \
${outgroupgbkpath}/ThioTMED218_NHJP01.gbk