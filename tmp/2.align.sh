#!/bin/bash

#SBATCH -J align
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/align.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/align.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 15
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-9

sample=$(cat /syn1/liangzhen/jinhua_jilab_project/result/WES/fastq/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)


cd /syn1/liangzhen/jinhua_jilab_project/result/WES/bam 

source /data/xieduo/WES_pipe/pipeline/bin/Miniconda3/bin/activate gatk_4.2.6.1

bwa mem -M -t 3 -R "@RG\tID:${sample}\tSM:${sample}\tPL:ILLUMINA\tLB:${sample}" /syn1/liangzhen/GATK_mm10_resource/GRCm38_68.fa /syn1/liangzhen/jinhua_jilab_project/result/WES/cleandata/${sample}_1.clean.fastq.gz /syn1/liangzhen/jinhua_jilab_project/result/WES/cleandata/${sample}_2.clean.fastq.gz > /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.sam && samtools view -bS /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.sam > /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam && rm -f /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.sam

samtools sort -o /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.sorted.bam -O bam -T ${sample} /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam 
mv /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.sorted.bam /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam 
samtools index /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam 

/data/xieduo/WES_pipe/pipeline/bin/gatk-4.2.6.1/gatk --java-options "-Xmx8G -Djava.io.tmpdir=./" MarkDuplicates I=/syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam O=/syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.rmdup.bam M=/syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.rmdup.metric VALIDATION_STRINGENCY=LENIENT 

samtools index /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.rmdup.bam 

/data/xieduo/WES_pipe/pipeline/bin/gatk-4.2.6.1/gatk --java-options "-Xmx8G" BaseRecalibrator -R /syn1/liangzhen/GATK_mm10_resource/GRCm38_68.fa -I /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.rmdup.bam --known-sites /syn1/liangzhen/GATK_mm10_resource/mgp.v5.merged.indels.dbSNP142.normed.vcf.gz --known-sites /syn1/liangzhen/GATK_mm10_resource/mgp.v5.merged.snps_all.dbSNP142.vcf.gz -O /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.recal_data.table
/data/xieduo/WES_pipe/pipeline/bin/gatk-4.2.6.1/gatk --java-options "-Xmx10G -Djava.io.tmpdir=./" ApplyBQSR -R /syn1/liangzhen/GATK_mm10_resource/GRCm38_68.fa -I /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.rmdup.bam -bqsr /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.recal_data.table -O /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.recal.bam 

rm /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.rmdup.bam 
rm /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.rmdup*bai 
mv /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.raw.bam 

samtools view -b -x BD -x BI -o /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.recal.bam 
rm /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.recal.bam && rm /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.recal.bai 

samtools index /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam 
samtools stats /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam > /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam.stats && samtools stats -d /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam > /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam.rmdup.stats && coverageBed -hist -abam /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam -b /syn1/liangzhen/WES_bed/agilent_mouse_region.mm10.bed | grep all > /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam.cov && samtools view -u -F 1024 /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam | coverageBed -hist -abam /dev/stdin -b /syn1/liangzhen/WES_bed/agilent_mouse_region.mm10.bed | grep all > /syn1/liangzhen/jinhua_jilab_project/result/WES/bam/${sample}.bam.rmdup.cov
