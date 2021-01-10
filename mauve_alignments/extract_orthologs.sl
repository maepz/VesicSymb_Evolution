#!/bin/bash 
#SBATCH --job-name=run_mauve_extract_orthologs
#SBATCH --account=def-bacc
#SBATCH --time=12:0:0
#SBATCH --mem-per-cpu=1G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=END
#SBATCH --error=%A_%a'.err' 
#SBATCH --output=%A_%a'.out' 

modula load java

MAUVE_DIR=~/software/mauve_snapshot_2015-02-13/Java
export CLASSPATH="$(find "$MAUVE_DIR" -name \*.jar -print0 | tr '\0' :)$CLASSPATH"

#java org.gel.mauve.analysis.OneToOneOrthologExporter -f ALL.xmfa -l 0.60 -n 0.8 -o ALL_id80cov60.orthologs -t gene
#java org.gel.mauve.analysis.OneToOneOrthologExporter -f ALL.xmfa -n 0.6 -l 0.51 -o ALL_id60cov51.orthologs -t gene
#java org.gel.mauve.analysis.OneToOneOrthologExporter -f ALL.xmfa -n 0.45 -l 0.51 -o ALL_id45cov51.orthologs -t gene
#java org.gel.mauve.analysis.OneToOneOrthologExporter -f ALL.xmfa -n 0.7 -l 0.51 -o ALL_id70cov51.orthologs -t gene
#java org.gel.mauve.analysis.OneToOneOrthologExporter -f ALL.xmfa -n 0.8 -l 0.51 -o ALL_id80cov51.orthologs -t gene
#java org.gel.mauve.analysis.OneToOneOrthologExporter -f ALL.xmfa -n 0.35 -l 0.51 -o ALL_id35cov51.orthologs -t gene
java org.gel.mauve.analysis.OneToOneOrthologExporter -f ALL.xmfa -n 0.30 -l 0.60 -o ALL_id35cov51.orthologs -t gene
java org.gel.mauve.analysis.OneToOneOrthologExporter -f ALL.xmfa -n 0.30 -l 0.51 -o ALL_id35cov51.orthologs -t gene