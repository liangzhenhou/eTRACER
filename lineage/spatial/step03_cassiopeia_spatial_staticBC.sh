#!/bin/bash
#SBATCH -J cassiopeia_EE_staticBC
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/EE/log/cassiopeia_EE_staticBC.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/EE/log/cassiopeia_EE_staticBC.error
#SBATCH -p all
#SBATCH -N 1                      
#SBATCH -n 25
#SBATCH --mem=150G
#SBATCH -t 00:00:00               



innerBC=staticBC
gene_name=staticBC
fastq_path=/syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/EE/fastq
outdir=/syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/EE/cassiopeia_result
mkdir -p ${outdir}


/home/liangzhen/anaconda3/envs/cassiopeia2/bin/python3.8 /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/EE/cassiopeia_func_static_barcode_spatial.py ${innerBC}_mapped ${gene_name}  ${outdir} ${fastq_path}
