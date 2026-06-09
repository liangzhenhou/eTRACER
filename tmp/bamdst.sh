#!/bin/bash

#SBATCH -J bamdst
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/bamdst.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/bamdst.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 15
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-9

sample=$(cat /syn1/liangzhen/jinhua_jilab_project/result/WES/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)


source /data/xieduo/WES_pipe/pipeline/bin/Miniconda3/bin/activate gatk_4.2.6.1
/data/xieduo/WES_pipe/pipeline/bin/bamdst/bamdst -p /syn1/liangzhen/WES_bed/agilent_mouse_region.mm10.fixed.bed -o /syn1/liangzhen/jinhua_jilab_project/result/WES/results/0.bamdst/${sample} /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam
