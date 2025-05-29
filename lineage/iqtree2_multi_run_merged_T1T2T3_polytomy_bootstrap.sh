#!/bin/bash

#SBATCH -J iqtree2_bootstrap
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/merge_all_experiments/log/iqtree2.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/merge_all_experiments/log/iqtree2.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 50
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-10


clone_info=$(cat /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/trees/merge_all_experiments/bootstrap/clone.mut.list | sed -n ${SLURM_ARRAY_TASK_ID}p)
clone=`echo ${clone_info} |awk -F, '{print $1}'`
model=`echo ${clone_info} |awk -F, '{print $2}'`

cd /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/trees/merge_all_experiments/bootstrap/
/home/kantian/miniconda3/envs/smalt/bin/iqtree2 -T 50 -s /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/trees/merge_all_experiments/bootstrap/${clone} -o 'synthetic' --polytomy -m ${model} -B 1000 -alrt 1000 --mlrate -asr -wslmr -wspmr 
