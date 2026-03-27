#!/bin/bash
#SBATCH -J macs2
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/bulk_ATAC/macs2.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/bulk_ATAC/macs2.error
#SBATCH -p all
#SBATCH -N 1  
#SBATCH -n 5
#SBATCH --mem=50G
#SBATCH -t 00:00:00               
#SBATCH --array=1-9


SAMPLE=$(cat /syn1/liangzhen/jinhua_jilab_project/data/bulkATAC/Data/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)
SAMPLENAME=`basename ${SAMPLE}`


cd /syn1/liangzhen/jinhua_jilab_project/result/bulkATAC/bowtie2

/home/liangzhen/anaconda3/envs/topact/bin/macs2 callpeak -f BAMPE --nomodel -g mm -B  --broad --keep-dup all --cutoff-analysis -n ${SAMPLENAME} -t ${SAMPLENAME}_sorted.bam --outdir ../macs2/${SAMPLENAME} 2> macs2.log

