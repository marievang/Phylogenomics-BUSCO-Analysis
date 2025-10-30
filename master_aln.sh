#!/usr/bin/bash

##Time
start=$(date +%s)


##Finds and counts unique busco ids for each species and sorts  then in descending order accortding to their count number.

#find /home1/koartemis/hagfish/busco_results/b_results/ -type f -path "*/run_*/full_table.tsv" -exec awk '!/^#/ && $2 == "Complete" { print $1 }' {} + | sort | uniq -c | sort -nr > /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt
##


##################################
#FInds how many unique species for each N

#find /home1/koartemis/hagfish/busco_results/b_results/ -type f -path "*/run_*/full_table.tsv" \
#-exec awk -v OFS="\t" '
#    {
#        n = split(FILENAME, path_parts, "/")
#        species = ""
#        for (i = 1; i <= n; i++) {
#            if (path_parts[i] ~ /^run_/) {
#                species = path_parts[i-1]
#                break
#            }
#        }
#    }
#    $0 !~ /^#/ && $2 == "Complete" && species != "" {
#        print $1, species
#    }
#' {} + | sort -u | awk '
#{
#    busco = $1
#    species = $2
#    key = busco
#    if (!(key in seen_species[busco])) {
#        seen_species[busco][species] = 1
#        busco_to_species[busco] = (busco in busco_to_species ? busco_to_species[busco] "," species : species)
#    }
#}
#END {
#    for (b in busco_to_species) {
#        print b, busco_to_species[b]
#    }
#}
#' > /home1/koartemis/hagfish/busco_genes/busco_ids_to_species.txt
#


# awk '
# {
#     n = split($2, species_list, ",")
#     for (i = 1; i <= n; i++) {
#         seen[n][species_list[i]] = 1
#     }
# }
# END {
#     for (count in seen) {
#         unique_count = 0
#         species_str = ""
#         sep = ""
#         for (s in seen[count]) {
#             unique_count++
#             species_str = species_str sep s
#             sep = ","
#         }
#         printf "BUSCOs with exactly %s species → %d unique species: %s\n", count, unique_count, species_str
#     }
# }
# ' /home1/koartemis/hagfish/busco_genes/busco_ids_to_species.txt | sort -nr > /home1/koartemis/hagfish/busco_genes/uniq_species.txt
#####################################################################3

##Finds sequences of unique busco ids and adds them in a .faa file hith the busco id and the species name in the header
########################33
## File needs to be in descending order with sort -nr

#find /home1/koartemis/hagfish/busco_results/b_results/ -type f -path "/run_*/busco_sequences/single_copy_busco_sequences/.faa"

out_path="/home1/koartemis/hagfish/three_up"

mkdir -p $out_path

if [ -z "$1" ]; then
    echo "Usage: $0 <keep_value>"
    exit 1
fi

keep=$1

# Validate: must be integer between 1 and 7
if ! [[ "$keep" =~ ^[0-7]$ ]] || [ "$keep" -eq 0 ]; then
    echo "Error: keep must be an integer between 1 and 7"
    exit 1
fi

max=7
i=0
fileN=$(wc -l /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt)

while read  count id; do 
    echo $count
    echo $id
    if [[ $count -ge $keep && $count -le $max ]]; then
        path=$(find /home1/koartemis/hagfish/busco_results/b_results_bu/ -type f -path "*/run_*/busco_sequences/single_copy_busco_sequences/${id}.faa")
        echo $path
        for file in $path; do
            species=$(echo $file | cut -f7 -d"/")
            sed "s/^>\(.*\)/>${species}|\1/" $file > "${out_path}/${species}_${id}.faa"
			((i++))
            echo $species
			echo "Done with ${i}/${fileN}" 
        done
    else 
        # skip lines outside of range
        break
    fi
done < /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt

# # Step 1: Pre-index all .faa files
# declare -A id_to_path
# while IFS= read -r line; do
#     filename=$(basename "$line")
#     id="${filename%%.faa}"
#     id_to_path["$id"]="$line"
# done < <(find /home1/koartemis/hagfish/busco_results/b_results_bu/ -type f -name "*.faa")

# echo "Indexed FAA file paths:"
# for id in "${!id_to_path[@]}"; do
#     echo "$id => ${id_to_path[$id]}"
# done
# echo ""

# processed_count=0

# # fileN=$(wc -l /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt)
# # # Step 2: Process input lines with early exit
# # while read -r count id; do
# #     # Since the file is in descending order, we can break early
# #     if (( count < keep )); then
# #         break
# #     fi

# #     if (( count <= max )); then
# #         file="${id_to_path[$id]}"
# #         if [[ -n "$file" && -f "$file" ]]; then
# #             species=$(echo "$file" | cut -f7 -d"/")
# #             awk -v species="$species" '{sub(/^>/, ">"species"|"); print}' "$file" > "${out_path}/${species}_${id}.faa"
# #             echo "Processed $species $id"
# # 			((processed_count++))
# #             echo "Done: ${processed_count}/${fileN}"
# #         fi
# #     fi
# # done < /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt


####################################################################################
#Align BUSCO genes with at least 6 species

#out_dir="/home1/koartemis/hagfish/mafft"
#
# ending=$(wc -l /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt) 
# i=0
#
# while read  count id; do 
#     ((i++))
#     echo "Starting ${i} / ${ending}"
#     if [[ $count -ge $keep && $count -le $max ]]; then
#         find /home1/koartemis/hagfish/busco_results/b_results/ -type f -path "*/run_*/busco_sequences/single_copy_busco_sequences/${id}.faa" -exec cat {} \; > "${out_dir}/${id}.fasta"
#         echo $id
#         echo "Results in ${out_dir}/${id}.fasta"
#     else 
#         exit
#     fi
# done < /home1/koartemis/hagfish/busco_genes/busco_ids_descending.txt
#


#==================================================================================================================
#trim the aligned genes with at least 6 species

## Trim alignments with trimAl
#ending=$(wc -l /home1/koartemis/hagfish/trimal) 
#i=0
#
#for align in "${out_dir}"/results/*.msa; do
#    ((i++))
#    echo "Starting ${i} / ${ending}"
#    cut_msa=$(basename "$align" .msa)
#    trimal -in "$align" -out "/home1/koartemis/hagfish/trimal/${cut_msa}_trimmed.fasta" -automated1
#    echo "Trimmed: ${cut_msa}_trimmed.fasta"
#done


##Time
end=$(date +%s)
echo "Elapsed Time: $(($end-$start)) seconds"
