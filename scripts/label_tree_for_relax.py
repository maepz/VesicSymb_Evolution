#!/usr/bin/env python

import argparse
import sys
import ete3
from ete3 import Tree
import os
from os.path import isfile, join




def add_labels_to_tree(input_tree_file):
    '''This function adds labels (symbiont genera or host-association) to terminal branches and internal nodes of a tree'''
    dic={'MS2017':'{fl}','SP60':'{fl}','Vmar':'{gigas}','HUE58':'{ruthia}','Vgig1':'{gigas}','Vgig2':'{gigas}','COSY':'{gigas}','Vdia':'{gigas}','Vext':'{gigas}','Vsoy1':'{gigas}','Vsoy2':'{gigas}','Rmag':'{ruthia}','Rpli':'{ruthia}','Rsou':'{ruthia}','Rpac':'{ruthia}','Rrec':'{ruthia}','Rpha':'{ruthia}'}
    dic2={'MS2017':'{fl}','SP60':'{fl}','Vmar':'{sym}','HUE58':'{sym}','Vgig1':'{sym}','Vgig2':'{sym}','COSY':'{sym}','Vdia':'{sym}','Vext':'{sym}','Vsoy1':'{sym}','Vsoy2':'{sym}','Rmag':'{sym}','Rpli':'{sym}','Rsou':'{sym}','Rpac':'{sym}','Rrec':'{sym}','Rpha':'{sym}'}
    tree=Tree(input_tree_file,format=1)
    tree2=Tree(input_tree_file,format=1)
#     fl_leafs=[leaf for leaf in tree.iter_leaf_names() if ('Bathy' in leaf) or ('SP60' in leaf)]
#     ancestor = tree.get_common_ancestor(fl_leafs)
#     tree.set_outgroup(ancestor)
#     tree2.set_outgroup(ancestor)
    
    for leaf in tree.iter_leaf_names():
        for item in leaf.split('_')[1:]:
            try:
                #tree1 = symbiont genera; fl for free-living, ruthia for Ca. Ruthia and gigas for Ca. Vesicomyiosocius
                new_leaf_name=leaf+dic[item]
                node=tree&leaf
                node.name=new_leaf_name

                #tree2 = host-association; fl for free-living, sym for symbiotic
                new_leaf_name2=leaf+dic2[item]
                node2=tree2&leaf
                node2.name=new_leaf_name2

            except KeyError:
                continue


    for node in tree.traverse():
        if len(set([l.name.split('_')[-1] for l in node.get_leaves()]))==1:
            if len(node.name) ==0:
                node.name=[l.name.split('_')[-1] for l in node.get_leaves()][0]

    tree1_output=tree.write(format=1)


    for node in tree2.traverse():
        if len(set([l.name.split('_')[-1] for l in node.get_leaves()]))==1:
            if len(node.name) ==0:
                node.name=[l.name.split('_')[-1] for l in node.get_leaves()][0]

    tree2_output= tree2.write(format=1)

    return tree.get_ascii(show_internal=True),tree1_output,tree2.get_ascii(show_internal=True), tree2_output


# In[85]:

if __name__=='__main__':

    parser = argparse.ArgumentParser(
        description = '** Label trees for relax ** This script will label the gene tree according to genera or host-assoctiation ',
        usage = 'label_tree_for_relax.py -dir <path to tree directory> -f <tree filename>')
    parser.add_argument('-dir', help='name of the directory where the tree file is', dest='root')
    parser.add_argument('-f', help='name of the tree file', dest='f')
    
    options = parser.parse_args()

root = options.root+'/'
f = options.f
    
sample=f.split('.')[0]
f=open(root+f,'r')
lines=f.read().splitlines()
f.close()
data=lines[0]

tree1,tree1_text,tree2,tree2_text=add_labels_to_tree(data)
#print( tree1)
with open(root+sample+'.genera.labeled_tree', 'w') as the_file:
    the_file.write(tree1_text)
#print( tree2)
with open(root+sample+'.host.labeled_tree', 'w') as the_file:
    the_file.write(tree1_text)
