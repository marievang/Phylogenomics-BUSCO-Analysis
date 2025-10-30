Hagfish phylogenomics pipeline

This repository contains a phylogenomics pipeline for processing BUSCO sequences and building a species tree from gene alignments.
The workflow contains scripts about:
1. Extracting single-copy BUSCO genes
2. Aligning (MAFFT)  and trimming (TrimAl) sequences
3. Inferring gene trees (FastTree,IQ-TREE) and species tree (wastraL)
4. Plotting unique sequence from the BUSCO results

   All the steps are summarizes in a main.sh script which ensures reproducibility and efficiency.
   A conda environment is used for the analysis.
Install dependencies via : requirements.txt


