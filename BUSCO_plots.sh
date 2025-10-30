

out_dir="/home1/koartemis/hagfish/busco_results/busco_plots"

for file in $(find /home1/koartemis/hagfish/busco_results/b_results_bu/ -maxdepth 2 -type f -name "short_summary.specific.*.txt"); do	
	cp $file $out_dir
done

python3 /home1/koartemis/.conda/pkgs/busco-5.8.0-pyhdfd78af_0/python-scripts/generate_plot.py -wd $out_dir
