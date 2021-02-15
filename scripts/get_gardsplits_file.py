#!/usr/bin/env python

import argparse
import json


if __name__=='__main__':

    parser = argparse.ArgumentParser(
        description = '** Get gard_splits file from gard output ** This script will generate the gard_splits file for aBSRel from the gard output ',
        usage = 'get_gardsplits_file.py -i <gard output json file> -out <output directory>')
    parser.add_argument('-i', help='gard output json file', dest='file')
    parser.add_argument('-out', help='path to output directory', dest='outdir')
    
    options = parser.parse_args()

file = options.file
outdir = options.outdir

gene=file.split('/')[-1].replace('.GARD.json','')

remote_file = open(file)
gard_json = json.load(remote_file)

if 'improvements' not in gard_json.keys():
    ### write gard_splits output for absrel
    entry='\n\n'
    entry+='-'.join(map(str,([i-1 for i in gard_json['breakpointData']['bps'][0]])))+'\n'+gard_json['breakpointData']['tree']+'\n'
    with open(outdir+'/'+gene+'.gard_splits','w') as fa:
        fa.write(entry) 

else:

    ### write gard_splits output for absrel
    entry='\n\n'
    for n in gard_json['breakpointData'].keys():
        entry+='-'.join(map(str,([i-1 for i in gard_json['breakpointData'][str(n)]['bps'][0]])))+'\n'+gard_json['breakpointData'][str(n)]['tree']+'\n'
    with open(outdir+'/'+gene+'.gard_splits','w') as fa:
        fa.write(entry)   