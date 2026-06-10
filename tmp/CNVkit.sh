#!/bin/bash

#SBATCH -J CNVkit
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/CNVkit.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/CNVkit.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 15
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-9

sample=$(cat /syn1/liangzhen/jinhua_jilab_project/result/WES/fastq/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)

source /home/liangzhen/anaconda3/bin/activate cnvkit

/home/liangzhen/anaconda3/envs/cnvkit/bin/cnvkit.py batch /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam -f /syn1/liangzhen/GATK_mm10_resource/GRCm38_68.fa -n -t /syn1/liangzhen/WES_bed/agilent_mouse_region.mm10.fixed.bed -d /syn1/liangzhen/jinhua_jilab_project/result/WES/results/3.CNVkit/${sample}/ --scatter --diagram
