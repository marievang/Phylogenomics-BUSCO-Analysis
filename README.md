# Hagfish Phylogenomics Pipeline 

> A phylogenomics workflow for processing BUSCO sequences, inferring gene trees, and reconstructing species trees using wASTRAL.

This repository contains a pipeline designed to automate the phylogenomic analysis of Hagfish (and other species). It takes **BUSCO** output results as input and performs the complete downstream analysis: from extracting single-copy orthologs to multiple sequence alignment, trimming, and final species tree inference.

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

##  Installation

1.  Clone the repository:
    ```bash
    git clone [https://github.com/your_username/hagfish-phylogenomics.git](https://github.com/your_username/hagfish-phylogenomics.git)
    cd hagfish-phylogenomics
    ```

2.  Create and activate the Conda environment:
    ```bash
    conda create -n phylogenomics python=3.9
    conda activate phylogenomics
    ```

3.  Install the required Python libraries and tools:
    ```bash
    pip install -r requirements.txt
    # Note: Ensure mafft, trimal, iqtree, etc., are installed in your path 
    # or install them via conda:
    # conda install -c bioconda mafft trimal fasttree iqtree aster
    ```
