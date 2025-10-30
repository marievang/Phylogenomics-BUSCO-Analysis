#!/usr/bin/env bash
# ============================================================
#  Main pipeline runner for phylogenomic workflow
#  
#  Description:
#  This master script coordinates the execution of all
#  pipeline steps (alignment, trimming, tree inference, etc.)
#  using the helper scripts in this directory.
#
# ============================================================

# -------------------------------
# 1. Configuration
# -------------------------------

# Exit immediately if a command exits with a non-zero status
set -e

# Treat unset variables as errors
set -u

#print each command before running (for debugging)
set -x

# Define directories
WORKDIR=$(pwd)
LOGDIR="$WORKDIR/logs"
OUTDIR="$WORKDIR/results"
DATADIR="$WORKDIR/genomes"
BUSCO_DIR="$WORKDIR/busco_results"
MAFFT_DIR="$WORKDIR/mafft"
TRIMAL_DIR="$WORKDIR/trimal"
TREES_DIR="$WORKDIR/trees"

# Create directories if they don't exist
mkdir -p "$LOGDIR" "$OUTDIR"

# -------------------------------
# 2. Define input files
# -------------------------------

# Example input variables (adjust as needed)
INPUT_SEQS="genome_names.txt"
GENE_TREES="cleaned_gene_trees.tre"

# -------------------------------
# 3. Define script paths
# -------------------------------

# Example script variables
GET_SEQS="$WORKDIR/get_seqs.py"
RUN_FASTTREE="$WORKDIR/run_fasttree.sh"
RUN_IQTREE="$WORKDIR/run_iqtree.sh"
RUN_MAFFT="$WORKDIR/run_mafft.sh"
RUN_TRIMAL="$WORKDIR/run_trimal.sh"
RUN_WASTRAL="$WORKDIR/run_wastral.sh"
PLOT_RESULTS="$WORKDIR/plot.py"

# -------------------------------
# 4. Helper functions
# -------------------------------

log_step() {
    echo -e "\n[INFO] $(date '+%Y-%m-%d %H:%M:%S') — $1"
}

# -------------------------------
# 5. Pipeline steps
# -------------------------------

#  Get sequences
log_step "Get sequence using busco."
python "$GET_SEQS" "$INPUT_SEQS" > "$LOGDIR/get_seqs.log" 2>&1

# Multiple sequence alignment (MAFFT)
log_step "Running MAFFT alignment..."
bash "$RUN_MAFFT" > "$LOGDIR/mafft.log" 2>&1

#Trimming alignments
log_step "Running Trimal..."
bash "$RUN_TRIMAL" > "$LOGDIR/trimal.log" 2>&1

#Gene tree inference
log_step "Running FastTree..."
bash "$RUN_FASTTREE" > "$LOGDIR/fasttree.log" 2>&1

# Species tree inference
log_step "Running WASTRAL..."
bash "$RUN_WASTRAL" > "$LOGDIR/wastral.log" 2>&1

# Plot results
log_step "Generating plots..."
python "$PLOT_RESULTS" > "$LOGDIR/plot.log" 2>&1



log_step "Pipeline completed successfully!"
echo "Results saved in: $OUTDIR"

#==========================================================
#!/usr/bin/env bash
#set -e

#echo "Running MAFFT..."
#bash run_mafft.sh > logs/mafft.log 2>&1

#echo "Running TrimAl..."
#bash run_trimal.sh > logs/trimal.log 2>&1

#echo "Running FastTree..."
#bash run_fasttree.sh > logs/fasttree.log 2>&1

#echo "Running WASTRAL..."
#bash run_wastral.sh > logs/wastral.log 2>&1

#echo "Plotting results..."
#python plot.py > logs/plot.log 2>&1

#echo "Pipeline complete!"
