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



out_path="/home1/koartemis/hagfish/three_parall"
mkdir -p "$out_path"

if [ -z "$1" ]; then
    echo "Usage: $0 <keep_value> [threads]"
    exit 1
fi

keep=$1
threads=${2:-20}  # Default to 4 threads if not specified

# Validate keep: integer between 1 and 7
if ! [[ "$keep" =~ ^[1-7]$ ]]; then
    echo "Error: keep must be an integer between 1 and 7"
    exit 1
fi

max=7
fileN=$(wc -l < /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt)

# process_line() {
#     count=$1
#     id=$2
#     out_path=$3

#     if [[ $count -ge $keep && $count -le $max ]]; then
#         paths=$(find /home1/koartemis/hagfish/busco_results/b_results_bu/ -type f -path "*/run_*/busco_sequences/single_copy_busco_sequences/${id}.faa")
#         for file in $paths; do
#             species=$(echo "$file" | cut -f7 -d"/")
#             sed "s/^>\(.*\)/>${species}|\1/" "$file" > "${out_path}/${species}_${id}.faa"
#             echo "Processed ${species} for ID ${id}"
#         done
#     fi
# }



# process_line() {
#     count=$1
#     id=$2
#     out_path=$3

#     echo "Processing ID: $id with count: $count"

#     if [[ $count -ge $keep && $count -le $max ]]; then
#         paths=$(find /home1/koartemis/hagfish/busco_results/b_results_bu/ -type f -path "*/run_*/busco_sequences/single_copy_busco_sequences/${id}.faa")
        
#         if [ -z "$paths" ]; then
#             echo "No files found for ID: $id"
#             return
#         fi

#         for file in $paths; do
#             species=$(echo "$file" | cut -f7 -d"/")
#             echo "Found file: $file for species: $species"
#             sed "s/^>\(.*\)/>${species}|\1/" "$file" > "${out_path}/${species}_${id}.faa"
#             echo "Wrote ${out_path}/${species}_${id}.faa"
#         done
#     else
#         echo "Skipping ID: $id due to count $count outside keep-max range"
#     fi
# }


# export -f process_line
# export out_path
# export keep
# export max

# # cat /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt | \
# #     awk -v k=$keep -v m=$max '$1 >= k && $1 <= m {print $0}' | \
# #     parallel -j "$threads" --bar --colsep ' ' process_line {1} {2} "$out_path"

# awk -v k=$keep -v m=$max '$1 >= k && $1 <= m {print $0}' /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt | \
# parallel -j "$threads" --bar process_line {1} {2} "$out_path"

# 

process_line() {
    #count=$1
    line=$1

	echo $line
	count=$(echo $line | cut -f1 -d" ")
	id=$(echo $line | cut -f2 -d" ")

    echo "Processing ID: $id with count: $count"

    if [[ $count -ge $keep && $count -le $max ]]; then
        paths=$(find /home1/koartemis/hagfish/busco_results/b_results_bu/ -type f -path "*/run_*/busco_sequences/single_copy_busco_sequences/${id}.faa")

        if [ -z "$paths" ]; then
            echo "No files found for ID: $id"
            return
        fi

        for file in $paths; do
            species=$(echo "$file" | cut -f7 -d"/")
            sed "s/^>\(.*\)/>${species}|\1/" "$file" > "${out_path}/${species}_${id}.faa"
            echo "Wrote ${out_path}/${species}_${id}.faa"
        done
    else
        echo "Skipping ID: $id due to count $count outside keep-max range"
    fi
}

export -f process_line
export out_path
export keep
export max

awk -v k=$keep -v m=$max '$1 >= k && $1 <= m {print $1, $2}' /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt | \
parallel -j "$threads" --bar process_line {1} {2}


echo "All done."
