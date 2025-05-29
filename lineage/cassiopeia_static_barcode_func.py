import pandas as pd
import cassiopeia as cas
import os
import cassiopeia
import gzip
import sys
import re
import numpy as np


gene_name = 'staticBC'
outdir = sys.argv[1] #'/data/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/T1/a3026/cassiopeia_result'

input_files = sys.argv[2].split(',')	
output_directory = outdir +'/' + gene_name
n_threads = 20
verbose = True
cassiopeia.pp.setup(output_directory, verbose=verbose)

# convert
bam_fp = cas.pp.convert_fastqs_to_unmapped_bam(
	input_files,
	chemistry='10xv3',
	output_directory=output_directory,
	name=gene_name,
	n_threads=n_threads
)

# filter_bam
bam_fp = cas.pp.filter_bam(
	bam_fp,
	output_directory=output_directory,
	quality_threshold=10,
	n_threads=n_threads,
)

# error_correct_cellbcs_to_whitelist
bam_fp = cas.pp.error_correct_cellbcs_to_whitelist(
  	bam_fp,
	whitelist='/data/liangzhen/jinhua_jilab_project/metadata/3M-february-2018.txt',
	output_directory=output_directory,
	n_threads=n_threads,
)

# collapse
umi_table = cas.pp.collapse_umis(
	bam_fp,
	output_directory=output_directory,
	max_hq_mismatches=3,
	max_indels=2,
	method='likelihood',
	n_threads=n_threads,
)

#umi_table = umi_table = pd.read_csv(output_directory+'/'+ gene_name + '_unmapped_filtered_corrected_sorted.collapsed.txt',header=0,sep='\t')

#resolve
umi_table = cas.pp.resolve_umi_sequence(
    umi_table,
    output_directory=output_directory,
    min_umi_per_cell=2,
    min_avg_reads_per_umi=2.0,
    plot=True,
)


umi_table['intBC'] = gene_name 

umi_table = cas.pp.error_correct_umis(
    umi_table,
    max_umi_distance=1,
    allow_allele_conflicts=False,
    n_threads=n_threads,
)

umi_table.to_csv(output_directory + '/' + 'umi_table_filtered.csv')

