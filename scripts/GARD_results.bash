#!/bin/bash

# Use this script to extract breakpoint information from GARD

ls *GTR.gard > GARD_files.txt
printf "Number of breakpoints detected\n" > GARD_results.txt 
while read -r line; do
	printf "%s " "$line" >> GARD_results.txt 
	grep -o -P 'GARD found evidence of.{0,13}' < $line >> GARD_results.txt
	grep -o -P 'GARD found no evidence of recombination' < $line >> GARD_results.txt
  
done < GARD_files.txt
