import pandas as pd
import cassiopeia as cas
import os
import cassiopeia
import gzip
import sys
import re

innerBC = sys.argv[1]
gene_name = sys.argv[2]
outdir = sys.argv[3]
fastq_path = sys.argv[4] + '/{}_{}.fq.gz'

input_files = [fastq_path.format(innerBC+'_corrected','r1'), fastq_path.format(innerBC,'r2')]	
name = gene_name
output_directory = outdir +'/' + gene_name
n_threads = 14
verbose = True
cassiopeia.pp.setup(output_directory, verbose=verbose)

# convert
bam_fp = cas.pp.convert_fastqs_to_unmapped_bam(
	input_files,
	chemistry='Stereo-seq',
	output_directory=output_directory,
	name=name,
	n_threads=n_threads
)

# filter_bam
bam_fp = cas.pp.filter_bam(
	bam_fp,
	output_directory=output_directory,
	quality_threshold=10,
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

#umi_table = pd.read_csv(output_directory+'/'+ gene_name + '_unmapped_filtered_sorted.collapsed.txt',header=0,sep='\t')

umi_table = cas.pp.resolve_umi_sequence(
    umi_table,
    output_directory=output_directory,
    min_umi_per_cell=1,
    min_avg_reads_per_umi=2.0,
    plot=False,
)

umi_table['intBC'] = gene_name 

umi_table = cas.pp.error_correct_umis(
            umi_table,
            max_umi_distance=1,
            allow_allele_conflicts=False,
            n_threads=10
        )



umi_table.to_csv(output_directory + '/' + 'umi_table_filtered.csv')
