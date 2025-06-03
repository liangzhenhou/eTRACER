#!/bin/bash

#SBATCH -J iqtree2
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/log/iqtree2.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/log/iqtree2.error
#SBATCH -p fat
#SBATCH -N 1                      # apply for one node
#SBATCH -n 5
#SBATCH --mem=200G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-103


clone=$(cat /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/trees/merge_all_experiments/T2_and_T3/polytomy/clone.mut.list | sed -n ${SLURM_ARRAY_TASK_ID}p)



cd /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/trees/merge_all_experiments/T2_and_T3/polytomy
/home/kantian/miniconda3/envs/smalt/bin/iqtree2 -s /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/trees/merge_all_experiments/T2_and_T3/polytomy/${clone} -o 'synthetic' --polytomy
