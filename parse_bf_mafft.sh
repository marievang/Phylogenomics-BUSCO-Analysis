#!/usr/bash

in_dir="/home1/koartemis/hagfish/three_parall"
out_dir="/home1/koartemis/hagfish/for_mafft"

mkdir -p $out_dir

ids=$(ls $in_dir | cut -f4 -d"_")

i=0
fileN=$(ls $in_dir | wc -l)

for file in $ids; do
	((i++))
	#echo $file
	for_each_id=$(ls $in_dir | grep $file)
	echo "Processing id: $file. ${i}/${fileN}"
	#cat "${in_dir}/${for_each_id}" > "${out_dir}/${file}"
	for each_species in $for_each_id; do
		cat "${in_dir}/${each_species}" >> "${out_dir}/${file}"
	done
done

