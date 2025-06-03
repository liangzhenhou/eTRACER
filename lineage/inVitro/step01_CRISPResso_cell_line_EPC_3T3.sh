#!/bin/bash

#SBATCH -J crispresso2_cell_line
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/In_vitro/log/crispresso2_cell_line.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/In_vitro/log/crispresso2_cell_line.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 1
#SBATCH --mem=10G
#SBATCH -t 00:00:00  
#SBATCH --array=1-61

crispr_gene=$(cat /syn1/liangzhen/jinhua_jilab_project/reference/EPC_cell_line_amplicon_reference_EPC_3T3.tsv | sed -n ${SLURM_ARRAY_TASK_ID}p)

gene_name=`echo ${crispr_gene} |awk  '{print $1}'`
gene_seq=`echo ${crispr_gene} |awk  '{print $2}'`
gene_sgRNA=`echo ${crispr_gene} |awk  '{print $3}'`
gene_wc=`echo ${crispr_gene} |awk  '{print $4}'`
gene_w=`echo ${crispr_gene} |awk  '{print $5}'`
inner_barcode=`echo ${crispr_gene} |awk  '{print $6}'`
homology=`echo ${crispr_gene} |awk  '{print $7}'`
time_point=`echo ${crispr_gene} |awk  '{print $8}'`
cell_line=`echo ${crispr_gene} |awk  '{print $9}'`
index=`echo ${crispr_gene} |awk  '{print $10}'`
Dox=`echo ${crispr_gene} |awk  '{print $11}'`

export PATH=$PATH:/home/liangzhen/anaconda3/envs/crispresso2/bin

cd /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/${time_point}/${cell_line}/${index}/crispresso2
mkdir -p /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/${time_point}/${cell_line}/${index}/crispresso2
cd /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/${time_point}/${cell_line}/${index}/crispresso2

/home/liangzhen/anaconda3/envs/crispresso2/bin/CRISPResso -r1 /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/${time_point}/${cell_line}/${index}/${inner_barcode}_r1.fq.gz -n ${gene_name}_${Dox}_r1 -a ${gene_seq} -g ${gene_sgRNA} -wc ${gene_wc} -w ${gene_w}  --default_min_aln_score ${homology} --plot_window_size 30 --ignore_substitutions --plot_histogram_outliers

/home/liangzhen/anaconda3/envs/crispresso2/bin/CRISPResso -r1 /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/${time_point}/${cell_line}/${index}/${inner_barcode}_r2.fq.gz -n ${gene_name}_${Dox}_r2 -a ${gene_seq} -g ${gene_sgRNA} -wc ${gene_wc} -w ${gene_w}  --default_min_aln_score ${homology} --plot_window_size 30 --ignore_substitutions --plot_histogram_outliers


