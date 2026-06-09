#!/bin/bash

#SBATCH -J readsQC
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/readsQC.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/readsQC.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 15
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-9

sample=$(cat /syn1/liangzhen/jinhua_jilab_project/result/WES/fastq/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)



source /data/xieduo/WES_pipe/pipeline/bin/Miniconda3/bin/activate gatk_4.2.6.1 

cd /syn1/liangzhen/jinhua_jilab_project/result/WES/cleandata

fastp --in1 /syn1/liangzhen/jinhua_jilab_project/result/WES/fastq/${sample}_1.fq.gz --out1 /syn1/liangzhen/jinhua_jilab_project/result/WES/cleandata/${sample}_1.clean.fastq.gz --in2 /syn1/liangzhen/jinhua_jilab_project/result/WES/fastq/${sample}_2.fq.gz --out2 /syn1/liangzhen/jinhua_jilab_project/result/WES/cleandata/${sample}_2.clean.fastq.gz -j /syn1/liangzhen/jinhua_jilab_project/result/WES/cleandata/EP1.fastp.json -h /syn1/liangzhen/jinhua_jilab_project/result/WES/cleandata/${sample}.fastp.html -q 5 -u 50 -w 2 -l 50 -n 5 -z 6
