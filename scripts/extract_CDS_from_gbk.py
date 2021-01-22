#!/usr/bin/env python
import argparse
import Bio
from Bio import SeqIO


if __name__=='__main__':

    parser = argparse.ArgumentParser(
        description = '** Extract CDS from genbank ** This script will extract CDS from a genbank file into a multifasta ',
        usage = 'extract_CDS_from_gbk.py -i <inputfile> -o <output file>')
    parser.add_argument('-i', help='input .gbk file', dest='inputfile')
    parser.add_argument('-o', help='output file name (should include .fasta)', dest='outputfile')
    
    options = parser.parse_args()

inputfile = options.inputfile
outputfile = options.outputfile

cds_records=[]
genome_name=inputfile.split('/')[-1].replace('.gbk','').split('_')[0]
for record in SeqIO.parse(inputfile,'genbank'):
    for feature in record.features:
        if feature.type != 'CDS': continue
        lc=feature.qualifiers['locus_tag'][0]
        cds=feature.extract(record)
        cds.id=genome_name+'|'+lc
        cds.description=''
        cds.name=''
        cds_records+=[cds]
SeqIO.write(cds_records,outputfile,'fasta')
