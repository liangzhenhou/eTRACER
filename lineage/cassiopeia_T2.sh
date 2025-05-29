#!/bin/bash

#SBATCH -J cassiopeia_T2
#SBATCH -o /synology/liangzhen/jinhua_jilab_project/script/AMPLICON/a3026/log/cassiopeia_T2.out       
#SBATCH -e /synology/liangzhen/jinhua_jilab_project/script/AMPLICON/a3026/log/cassiopeia_T2.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 15
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-15


gene_info=$(cat /synology/liangzhen/jinhua_jilab_project/reference/EPC_scRNA-seq_amplicon_reference.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
cut_sites=(0 80 91 93 87 63 89 89 84 86 94 48 87 89 85 89)

innerBC=`echo ${gene_info} | awk '{print $6}' `
gene_name=`echo ${gene_info} | awk '{print $1}' `
timePoint=T2
cut_site=`echo ${cut_sites[${SLURM_ARRAY_TASK_ID}]} `
fastq_path=/synology/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/${timePoint}/a3026/fastq
outdir=/synology/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/${timePoint}/a3026/cassiopeia_result
mkdir -p ${outdir}


/home/liangzhen/anaconda3/envs/cassiopeia2/bin/python3.8 /synology/liangzhen/jinhua_jilab_project/script/AMPLICON/a3026/cassiopeia_func.py ${innerBC} ${gene_name}  ${cut_site} ${outdir} ${fastq_path}
