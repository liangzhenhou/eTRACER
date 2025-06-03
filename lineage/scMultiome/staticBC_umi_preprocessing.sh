#!/bin/bash

#SBATCH -J staticBC_umi_preprocessing
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/multiome/RNA/log/staticBC_umi_preprocessing.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/multiome/RNA/log/staticBC_umi_preprocessing.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 20
#SBATCH --mem=100G
#SBATCH -t 00:00:00                # time limitation

outdir='/syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/multiome/cassiopeia_result' 
fastq_path='/syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/multiome/fastq/staticBC_{}.fq.gz'


/home/liangzhen/anaconda3/envs/cassiopeia2/bin/python3.8 /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/multiome/RNA/staticBC_umi_preprocessing.py ${outdir} ${fastq_path}
