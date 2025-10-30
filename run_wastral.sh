#!/bin/bash

#SBATCH --partition=fat
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --job-name="astral"
#SBATCH --output=slurm-%A_%a.out
#SBATCH --mail-user=emikotoula@hotmail.com
#SBATCH --mail-type=ALL
#SBATCH --requeue
#SBATCH --mem-per-cpu=12gb           # Memory per processor

IN_DIR="/home1/koartemis/hagfish/wastral32/"
#mkdir -p $IN_DIR

#IN_FILE="${IN_DIR}/FOR_ASTRAL_cleaned_gene_trees.tre"

wastral -x 100 -n 0 -r 16 -s 16 -i cleaned_gene_trees.tre -t 40 -o ${IN_DIR}/species_tree_old.tre
