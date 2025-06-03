#!/bin/bash

#SBATCH -J iqtree2
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/T2/log/iqtree2.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/T2/log/iqtree2.error
#SBATCH -p fat
#SBATCH -N 1                      # apply for one node
#SBATCH -n 5
#SBATCH --mem=100G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-18

clone=$(cat /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/trees/bin50/clone.mut.list | sed -n ${SLURM_ARRAY_TASK_ID}p)


cd /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/trees/bin50/
/home/kantian/miniconda3/envs/smalt/bin/iqtree2 -s /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/trees/bin50/${clone} -o 'synthetic' --polytomy
