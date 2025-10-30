#!/bin/bash

#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --job-name="parall_mast"
#SBATCH --output=slurm-%A_%a.out
#SBATCH --mail-user=emikotoula@hotmail.com
#SBATCH --mail-type=ALL
#SBATCH --requeue
#SBATCH --mem-per-cpu=6gb           # Memory per processor



in_dir="/home1/koartemis/hagfish/three_parall"
out_dir="/home1/koartemis/hagfish/parall_for_mafft"

mkdir -p "$out_dir"

# Extract unique IDs from filenames
ids=$(ls "$in_dir" | cut -f4 -d"_" | sort | uniq)

# Export variables and functions for GNU parallel
export in_dir out_dir

process_id() {
    id="$1"
    out_file="${out_dir}/${id}"
    > "$out_file"  # truncate or create the output file
    grep "$id" <(ls "$in_dir") | while read -r file; do
        cat "${in_dir}/${file}" >> "${out_file}"
    done
    echo "Finished processing ID: $id"
}

export -f process_id

# Run in parallel
echo "$ids" | parallel --jobs 20 process_id
