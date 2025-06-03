import pandas as pd
import cassiopeia as cas
import os
import cassiopeia
import gzip
import sys
import re

innerBC = sys.argv[1]
gene_name = sys.argv[2]
cut_site = sys.argv[3] 
outdir = sys.argv[4]
fastq_path = sys.argv[5] + '/{}_{}.fq.gz'

input_files = [fastq_path.format(innerBC+'_corrected','r1'), fastq_path.format(innerBC,'r2')]	
name = gene_name
output_directory = outdir +'/' + gene_name
reference_filepath = '/syn1/liangzhen/jinhua_jilab_project/reference/cassiopeia_cDNA_reference/' + gene_name+'.fa'
n_threads = 10
allow_allele_conflicts = False
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
umi_table = cas.pp.resolve_umi_sequence(
    umi_table,
    output_directory=output_directory,
    min_umi_per_cell=1, # defult 10
    min_avg_reads_per_umi=2.0,
    plot=False,
)

umi_table = cas.pp.align_sequences(
    umi_table,
    ref_filepath=reference_filepath,
    gap_open_penalty=20,
    gap_extend_penalty=1,
    n_threads=n_threads,
)

umi_table = cas.pp.call_alleles(
    umi_table,
    ref_filepath=reference_filepath,
    barcode_interval=(0, 0),
    cutsite_locations=[int(cut_site)],
    cutsite_width=30,
    context=False,
)


umi_table.to_csv(output_directory + '/' + 'umi_table.csv')

#print(cut_site)

def M_length_stat(cigar):
    length_M = 0
    cigar_chunks = re.findall(r"(\d+)?([A-Za-z])?", cigar)
    for chunk in cigar_chunks:
        if chunk[1] == "":
            continue
        length, _type = int(chunk[0]), chunk[1]
        if _type == "M":
            length_M = length_M + length
    return(length_M)

def indel_num_stat(r1):
    if 'None' in r1 or r1 == '':
        return 0
    indel_chunks = re.findall(r"(\d+)?([A-Za-z])?", r1)
    num = 0
    for chunk in indel_chunks:
        if chunk[1] == "" or chunk[0] == "":
            continue
        length, _type = int(chunk[0]), chunk[1]
        num += 1
    return(num)

def reads_indel_num_stat(cigar):
    num = 0
    indel_chunks = re.findall(r"(\d+)?([A-Za-z])?", cigar)
    for chunk in indel_chunks:
        if chunk[1] == "" or chunk[1] == "M":
            continue
        length, _type = int(chunk[0]), chunk[1]
        num += 1
    return(num)

def indel_length_stat(r1):
    total_length = 0
    if 'None' in r1 or r1 =='':
        return 0
    indel_chunks = re.findall(r"(\d+)?([A-Za-z])?", r1)
    for chunk in indel_chunks:
        if chunk[1] == "" or chunk[0] == "":
            continue
        length, _type = int(chunk[0]), chunk[1]
        total_length = total_length + length
    return total_length

def reads_indel_length_stat(cigar):
    total_length = 0
    indel_chunks = re.findall(r"(\d+)?([A-Za-z])?", cigar)
    for chunk in indel_chunks:
        if chunk[1] == "" or chunk[1] == 'M':
            continue
        length, _type = int(chunk[0]), chunk[1]
        total_length = total_length + length
    return total_length


umi_table = pd.read_csv(output_directory + '/' + 'umi_table.csv',
                               sep=',',index_col=0,header=0,keep_default_na=False)
umi_table['intBC'] = gene_name
umi_table = umi_table[umi_table['r1']!='']

umi_table['indel_num'] = umi_table['r1'].apply(indel_num_stat) 
umi_table['reads_indel_num'] = umi_table['CIGAR'].apply(reads_indel_num_stat)


umi_table['indel_length'] = umi_table['r1'].apply(indel_length_stat)
umi_table['reads_indel_length'] = umi_table['CIGAR'].apply(reads_indel_length_stat)

umi_table['length_M'] = umi_table['CIGAR'].apply(M_length_stat)


import re
def get_mismatch(alignment):
    #print(alignment)
    query = alignment[0]
    reference = alignment[1]
    query_begin = alignment[2]
    reference_begin = alignment[3]
    cigar = alignment[4]
    query_position = query_begin
    reference_position = reference_begin
    matches = re.findall(r'(\d+)([MIDNSHP=X])', cigar)
    mismatch_info = []
    for count, action in matches:
        count = int(count)
        if action == 'M':
            for i in range(count):
                query_base = query[query_position]
                reference_base = reference[reference_position]
                if query_base.upper() == reference_base.upper():
                    pass
                else:
                    mismatch_info.append([reference_position+1,reference_base+'>'+query_base])
                query_position += 1
                reference_position += 1
        elif action == 'I':
                query_position += count
        elif action == 'D':
                reference_position += count
        elif action == 'N':
                reference_position += count
        elif action == 'S':
                query_position += count 
        elif action == 'H':
                query_position += count

    return mismatch_info

ref = pd.read_csv(reference_filepath)
umi_table['Ref'] = ref.iloc[0,0]
umi_table['Mismatch'] = umi_table[['Seq','Ref','QueryBegin','ReferenceBegin','CIGAR']].apply(get_mismatch,axis=1)
umi_table['Mismatch_num'] = umi_table['Mismatch'].apply(len)

umi_table = cas.pp.error_correct_umis(
            umi_table,
            max_umi_distance=1,
            allow_allele_conflicts=True,
            n_threads=10
        )



umi_table.to_csv(output_directory + '/' + 'umi_table_filtered.csv')
