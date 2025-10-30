#!/bin/bash

#SBATCH --partition=fat
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --job-name="iqtree"
#SBATCH --output=slurm-%A_%a.out
#SBATCH --mail-user=emikotoula@hotmail.com
#SBATCH --mail-type=ALL
#SBATCH --requeue
#SBATCH --mem-per-cpu=12gb           # Memory per processor

##Time
start=$(date +%s)

in_path="/home1/koartemis/hagfish/trimal"
out_path="/home1/koartemis/hagfish/trees/"

fileN=$(ls "$in_path" | grep ".fasta"| wc -l)
i=0

for file in $(ls "$in_path" | grep ".fasta"); do
	((i++))
	echo "Processing file: $file. Number ${i} / ${fileN}"
	name=$(echo $file | cut -d"_" -f1 )
	iqtree -s "${in_path}/${file}" -m MFP -T AUTO --prefix "${out_path}/${name}" -t PARS -mem 480G
done


##Time
end=$(date +%s)
echo "Elapsed Time: $(($end-$start)) seconds"

