# Phylogenomics Pipeline Using BUSCO genes 

> A phylogenomics workflow for processing BUSCO sequences, inferring gene trees, and reconstructing species trees using wASTRAL.

This repository contains a pipeline designed to automate phylogenomic analysis and species tree creation using Benchmarking Universal Single-Copy Orthologs (BUSCO). It uses the **BUSCO** output as input and performs the complete downstream analysis: from extracting single-copy orthologs to multiple sequence alignment, trimming, and the final species tree inference. The pipeline was originally created for the analysis of several vertebrate species.

## Pipeline Workflow

The analysis contains the four following steps.

### 1. Data Extraction
* Parses BUSCO output directories.
* Extracts **Single-Copy Orthologs (SCOs)** shared across species.
* Filters out sequences that do not meet quality thresholds.

### 2. Alignment & Trimming
* **MAFFT:** Performs multiple sequence alignment for each gene.
* **TrimAl:** Removes poorly aligned regions  to reduce noise.

### 3. Tree Inference
* **Gene Trees:** Infers individual gene trees using **FastTree** (for speed) or **IQ-TREE** (for accuracy).
* **Species Tree:** Coalesces the gene trees into a final species tree using **wASTRAL** (weighted ASTRAL) to account for gene discordance.

### 4. Visualization
* Generates plots to visualize the distribution of unique sequences and BUSCO recovery rates across samples.

##  Prerequisites

The pipeline relies on a **Conda** environment to manage dependencies. 

### Dependencies
The main tools used in this pipeline are:
* [MAFFT](https://mafft.cbrc.jp/alignment/software/) (Alignment)
* [TrimAl](http://trimal.cgenomics.org/) (Trimming)
* [FastTree](http://www.microbesonline.org/fasttree/) / [IQ-TREE](http://www.iqtree.org/) (Gene Trees)
* [wASTRAL](https://github.com/chaoszhang/ASTER) (Species Tree)
* Python 3.x (Scripting & Plotting)

  Install the required Python libraries and tools:
    ```bash
    pip install -r requirements.txt
    # Note: Ensure mafft, trimal, iqtree, etc., are installed in your path 
    # or install them via conda:
    # conda install -c bioconda mafft trimal fasttree iqtree aster
    ```
