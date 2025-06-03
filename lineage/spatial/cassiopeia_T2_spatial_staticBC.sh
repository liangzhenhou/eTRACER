#!/bin/bash
#SBATCH -J cassiopeia_T2_staticBC
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/T2/log/cassiopeia_T2_staticBC.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/T2/log/cassiopeia_T2_staticBC.error
#SBATCH -p all
#SBATCH -N 1                      
#SBATCH -n 25
#SBATCH --mem=150G
#SBATCH -t 00:00:00               



innerBC=staticBC
gene_name=staticBC
fastq_path=/syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/fastq
outdir=/syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/cassiopeia_result
mkdir -p ${outdir}


/home/liangzhen/anaconda3/envs/cassiopeia2/bin/python3.8 /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/T2/cassiopeia_func_staticBC.py ${innerBC}_mapped ${gene_name}  ${outdir} ${fastq_path}
