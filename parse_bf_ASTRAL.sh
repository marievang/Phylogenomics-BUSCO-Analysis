#!/bin/bash

# Set input directory containing .tre files
INPUT_DIR="/home1/koartemis/hagfish/FastTrees3/" 
OUTPUT_DIR="/home1/koartemis/hagfish/wastral3/"
OUTPUT_FILE="${OUTPUT_DIR}/FOR_ASTRAL_cleaned_gene_trees.tre"
# Empty or create output file
> $OUTPUT_FILE

fileN=$(ls "$INPUT_DIR" | wc -l)
i=0

# Process each .tre file in the directory
for file in "$INPUT_DIR"/*; do
	((i++))
	echo "Processing file: $file. Number ${i} / ${fileN}"
    while read -r line; do
        # Replace full taxon names with species code before the first underscore
        cleaned=$(echo "$line" | sed -E 's/\b([A-Za-z0-9]+)_[^,:;)]+/\1/g')
        echo "$cleaned" >> "$OUTPUT_FILE"
    done < "$file"
done

echo "Finished! Output written to $OUTPUT_FILE"
