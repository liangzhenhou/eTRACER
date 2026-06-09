#!/bin/bash

#SBATCH -J readcounter
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/readcounter.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/readcounter.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 15
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-9

sample=$(cat /syn1/liangzhen/jinhua_jilab_project/result/WES/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)


cd /syn1/liangzhen/jinhua_jilab_project/result/WES/results/3.Titan && source ~/.bash_profile && source /data/xieduo/WES_pipe/pipeline/bin/Miniconda3/bin/activate gatk_4.2.6.1 && samtools mpileup -R -q 1 -d 1000 -uv -I -f /syn1/liangzhen/GATK_mm10_resource/GRCm38_68.fa   /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam | bcftools call -v -c - | /syn1/xieduo/software/jdk-11.0.1/bin/java -Xmx2g -jar /data/xieduo/WES_pipe/pipeline/bin/snpEff/SnpSift.jar filter "isHet( GEN[0] ) & (QUAL>20) & ( DP >= 10  ) & ( DP4[2] > 0 ) & ( DP4[3] > 0 )" > /syn1/liangzhen/jinhua_jilab_project/result/WES/results/3.Titan/${sample}.titancna.vcf && readCounter -w 1000 -q 1 -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,X,Y /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam > /syn1/liangzhen/jinhua_jilab_project/result/WES/results/3.Titan/${sample}.readcount.wig
