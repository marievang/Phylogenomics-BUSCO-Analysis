#!/bin/bash

# Trim alignments with trimAl
in_dir="/home1/koartemis/hagfish/mafft3"
out_dir="/home1/koartemis/hagfish/trimal3"

mkdir -p $out_dir

ending=$(ls $in_dir | wc -l ) 
i=0

for align in "${in_dir}"/*.faa; do
	echo $align
	((i++))
   name=$(echo $align | cut -f6 -d"/" | cut -f1 -d".")
   echo "Starting ${i} / ${ending}"
   trimal -in "$align" -out "$out_dir/${name}_trimmed.fasta" -automated1
   echo "Trimmed: ${name}_trimmed.fasta"
done

echo "All Done"
