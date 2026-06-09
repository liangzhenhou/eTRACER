#!/bin/bash

#SBATCH -J Mutect2
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/mutect2.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/mutect2.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 15
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-9

sample=$(cat /syn1/liangzhen/jinhua_jilab_project/result/WES/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)


cd /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect && source /data/xieduo/WES_pipe/pipeline/bin/Miniconda3/bin/activate gatk_4.2.6.1 && /data/xieduo/WES_pipe/pipeline/bin/gatk-4.2.6.1/gatk --java-options '-Xmx5g' Mutect2 \
 -R /syn1/liangzhen/GATK_mm10_resource/GRCm38_68.fa \
 --intervals /syn1/liangzhen/WES_bed/agilent_mouse_region.mm10.fixed.bed --interval-padding 100 \
 -I /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam \
 --germline-resource /syn1/liangzhen/GATK_mm10_resource/mgp.v5.merged.snps_all.dbSNP142.AF.vcf.gz \
 -O /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.vcf 

/data/xieduo/WES_pipe/pipeline/bin/gatk-4.2.6.1/gatk --java-options '-Xmx2g' FilterMutectCalls \
 -R /syn1/liangzhen/GATK_mm10_resource/GRCm38_68.fa \
 -V /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.vcf \
 -O /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.vcf.gz

zcat /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.vcf.gz| awk '$7=="PASS"||$1~"^#"'  > /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.vcf

