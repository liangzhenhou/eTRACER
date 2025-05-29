#!/bin/bash

#SBATCH -J staticBC_umi_preprocessing_T1
#SBATCH -o /data/liangzhen/jinhua_jilab_project/script/AMPLICON/a3026/log/staticBC_umi_preprocessing_T1.out       
#SBATCH -e /data/liangzhen/jinhua_jilab_project/script/AMPLICON/a3026/log/staticBC_umi_preprocessing_T1.error
#SBATCH -p fat
#SBATCH -N 1                      # apply for one node
#SBATCH -n 20
#SBATCH --mem=100G
#SBATCH -t 00:00:00                # time limitation


outdir='/data/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/T1/a3026/cassiopeia_result'
fastq_path='/data/liangzhen/jinhua_jilab_project/data/DNA_Amplicon/a3026/T1/staticBC_R1.fastq.gz,/data/liangzhen/jinhua_jilab_project/data/DNA_Amplicon/a3026/T1/staticBC_R2.fastq.gz'

/home/liangzhen/anaconda3/envs/cassiopeia/bin/python3.8 cassiopeia_static_barcode_func.py ${outdir} ${fastq_path}
