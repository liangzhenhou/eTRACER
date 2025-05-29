#!/bin/bash
#SBATCH -J cellranger_T2
#SBATCH -o /data/liangzhen/jinhua_jilab_project/script/SCRNA/log/cellranger_T2_count.out       
#SBATCH -e /data/liangzhen/jinhua_jilab_project/script/SCRNA/log/cellranger_T2_count.error
#SBATCH -p fat
#SBATCH -N 1               
#SBATCH -n 24
#SBATCH --mem=100G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-3




WORKDIR='/data/liangzhen/jinhua_jilab_project/result/scRNA/cellranger/T2_cellranger_count'
cd $WORKDIR

sample=$(cat /data/liangzhen/jinhua_jilab_project/data/scRNA/T2/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)


#/data/zhaolian/software/cellranger-7.1.0/bin/cellranger multi --id=${sample} --csv=/data/liangzhen/jinhua_jilab_project/data/scRNA/T2/conf/${sample}_conf.csv --localcores=24 

/data/zhaolian/software/cellranger-7.1.0/bin/cellranger count --id=${sample} --csv=/data/liangzhen/jinhua_jilab_project/data/scRNA/T2/conf/${sample}_conf.csv --localcores=24 


