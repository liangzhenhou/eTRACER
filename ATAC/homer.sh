#!/bin/bash
#SBATCH -J findMotif
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/bulk_ATAC/findMotif.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/bulk_ATAC/findMotif.error
#SBATCH -p fat
#SBATCH -N 1  
#SBATCH -n 5
#SBATCH --mem=10G
#SBATCH -t 00:00:00               
#SBATCH --array=1-4


content=$(cat /syn1/liangzhen/jinhua_jilab_project/result/bulkATAC/motif/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)
sample=`echo ${content} | awk -F ',' '{print $1}'`
background=`echo ${content} | awk -F ',' '{print $2}'`

/home/liangzhen/tools/bin/findMotifsGenome.pl /syn1/liangzhen/jinhua_jilab_project/result/bulkATAC/motif/${sample}.bed mm10r /syn1/liangzhen/jinhua_jilab_project/result/bulkATAC/motif/${sample} -bg /syn1/liangzhen/jinhua_jilab_project/result/bulkATAC/motif/${background}.bed
