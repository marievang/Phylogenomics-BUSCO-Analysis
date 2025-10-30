#!/bin/bash

#SBATCH --partition=fat
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --job-name="mafft"
#SBATCH --output=slurm-%A_%a.out
#SBATCH --mail-user=emikotoula@hotmail.com
#SBATCH --mail-type=ALL
#SBATCH --requeue
#SBATCH --mem-per-cpu=12gb           # Memory per processor


in_dir="/home1/koartemis/hagfish/parall_for_mafft"
out_dir="/home1/koartemis/hagfish/mafft3"


# Trim alignments with trimAl
i=0
ending=$(ls $in_dir | wc -l)

for fasta in "${in_dir}"/*.faa; do
   ((i++))
   echo "Starting ${i} / ${ending}"
   name=$(echo $fasta | cut -f6 -d"/")
   mafft --auto --thread 40 "${fasta}" > "${out_dir}/${name}"
   echo "Done"
done

echo "All Done"
