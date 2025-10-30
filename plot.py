# #
# #counts = []
# #
# #with open('/home1/koartemis/hagfish/busco_genes/busco_ids.txt', 'r') as f:
# #    for line in f:
# #        parts = line.strip().split()
# #        if len(parts) == 2:
# #            count = int(parts[0])  # number of organisms
# #            gene = parts[1]        # BUSCO ID (e.g., BUSCO_0001)
# #            counts.append(count)
# #
# #from collections import Counter
# #import matplotlib.pyplot as plt
# #
# ## Count how many genes are found in N organisms
# #frequency = Counter(counts)
# #
# ## Sort and prepare data for plotting
# #x = sorted(frequency)
# #y = [frequency[n] for n in x]
# #
# ## Plot
# #plt.figure(figsize=(10, 6))
# #plt.bar(x, y, color='skyblue', edgecolor='black')
# #plt.xlabel('Number of organisms a BUSCO gene is found in')
# #plt.ylabel('Number of BUSCO genes')
# #plt.title('BUSCO Gene Distribution Across Organisms')
# #plt.xticks(x)
# #plt.grid(axis='y', linestyle='--', alpha=0.7)
# #plt.tight_layout()
# ##plt.show()
# #plt.savefig('busco_gene_distribution.png', dpi=300)
# #

# import sys
# from collections import Counter
# import matplotlib.pyplot as plt

# # Check for command-line argument
# if len(sys.argv) != 2:
#     print(f"Usage: {sys.argv[0]} <min_organisms>")
#     sys.exit(1)

# # Minimum count threshold from input
# min_organisms = int(sys.argv[1])

# counts = []

# with open('/home1/koartemis/hagfish/busco_genes/busco_ids.txt', 'r') as f:
#     for line in f:
#         parts = line.strip().split()
#         if len(parts) == 2:
#             count = int(parts[0])
#             if count >= min_organisms:
#                 counts.append(count)

# # Count how many genes are found in N organisms
# frequency = Counter(counts)

# # Sort and prepare data for plotting
# x = sorted(frequency)
# y = [frequency[n] for n in x]

# # Plot
# plt.figure(figsize=(10, 6))
# plt.bar(x, y, color='skyblue', edgecolor='black')
# plt.xlabel('Number of organisms a BUSCO gene is found in')
# plt.ylabel('Number of BUSCO genes')
# plt.title(f'BUSCO Gene Distribution (≥ {min_organisms} organisms)')
# plt.xticks(x)
# plt.grid(axis='y', linestyle='--', alpha=0.7)
# plt.tight_layout()

# # Save plot
# plt.savefig('busco_gene_distribution_new.png', dpi=300)


# import sys
# from collections import Counter
# import matplotlib.pyplot as plt
# import matplotlib.ticker as ticker

# # CLI arg: minimum organism count
# if len(sys.argv) != 2:
#     print(f"Usage: {sys.argv[0]} <min_organisms>")
#     sys.exit(1)

# min_organisms = int(sys.argv[1])
# counts = []

# # Load data
# with open('/home1/koartemis/hagfish/busco_genes/busco_ids.txt', 'r') as f:
#     for line in f:
#         parts = line.strip().split()
#         if len(parts) == 2:
#             count = int(parts[0])
#             if count >= min_organisms:
#                 counts.append(count)

# # Count how many genes per number of organisms
# frequency = Counter(counts)
# x = sorted(frequency)
# y = [frequency[n] for n in x]

# # === PRETTIER PLOT SETUP ===
# plt.style.use('seaborn-v0_8-whitegrid')
# plt.rcParams.update({
#     'font.size': 12,
#     'axes.titlesize': 16,
#     'axes.labelsize': 14,
#     'xtick.labelsize': 12,
#     'ytick.labelsize': 12,
#     'font.family': 'DejaVu Sans'
# })

# fig, ax = plt.subplots(figsize=(10, 6))
# bars = ax.bar(x, y, color='#5DA5DA', edgecolor='black', width=0.6)

# # Use log scale on Y
# ax.set_yscale('log')
# ax.yaxis.set_major_formatter(ticker.FuncFormatter(lambda y, _: f'{int(y):,}' if y < 10000 else f'{int(y/1000)}K'))

# # Label bars with values
# for xi, yi in zip(x, y):
#     ax.text(xi, yi * 1.05, f'{yi:,}', ha='center', va='bottom', fontsize=10)

# # Labels & title
# ax.set_xlabel('Number of organisms a BUSCO gene is found in')
# ax.set_ylabel('Number of BUSCO genes (log scale)')
# ax.set_title(f'BUSCO Gene Distribution (≥ {min_organisms} organisms)')

# # Ticks
# ax.set_xticks(x)
# ax.tick_params(axis='both', which='major', length=5)

# plt.tight_layout()
# plt.savefig('busco_gene_distribution_pretty.png', dpi=300)


import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import ScalarFormatter
from matplotlib.patches import Patch

# BUSCO distribution data
x = [1, 2, 3, 4, 5, 6, 7]
y = [34793, 1980, 6398, 473, 748, 592, 670]

# Unique species diversity for each BUSCO count
species_diversity = {
    1: 14,
    2: 10,
    3: 10,
    4: 7,
    5: 7,
    6: 7,
    7: 7
}

# Color map for diversity
color_map = {
    14: '#1f77b4',  # dark blue
    10: '#6baed6',  # medium blue
    7:  '#c6dbef',  # light blue
}

# Assign color to each bar
bar_colors = [color_map.get(species_diversity[n], '#dddddd') for n in x]

# Create figure and axes
fig, ax = plt.subplots(figsize=(10, 6))

# Use log scale on y-axis
ax.set_yscale('log')

# Plot bars
bars = ax.bar(x, y, color=bar_colors, edgecolor='black', width=0.6)

# Add value labels above bars
for bar in bars:
    height = bar.get_height()
    ax.annotate(f'{int(height)}',
                xy=(bar.get_x() + bar.get_width() / 2, height),
                xytext=(0, 4),
                textcoords="offset points",
                ha='center', va='bottom', fontsize=9)

# Set axis labels and title
ax.set_xlabel('Number of organisms a BUSCO gene is found in', fontsize=12)
ax.set_ylabel('Number of BUSCO genes (log scale)', fontsize=12)
ax.set_title('BUSCO Gene Distribution (≥ 1 organisms)', fontsize=14)

# Ticks
ax.set_xticks(x)
ax.yaxis.set_major_formatter(ScalarFormatter())  # show actual numbers, not scientific notation

# Legend for diversity
legend_elements = [
    Patch(facecolor=color_map[14], label='14 unique species'),
    Patch(facecolor=color_map[10], label='10 unique species'),
    Patch(facecolor=color_map[7],  label='7 unique species')
]
ax.legend(handles=legend_elements, title='BUSCO Diversity', loc='upper right', fontsize=10, title_fontsize=11)

# Layout and display
plt.tight_layout()
plt.savefig('busco_gene_distribution_uniq.png', dpi=300)
