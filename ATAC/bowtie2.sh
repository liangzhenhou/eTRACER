#!/bin/bash
#SBATCH -J bowtie2                   
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/bulk_ATAC/bowtie2.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/bulk_ATAC/bowtie2.error
#SBATCH -p all
#SBATCH -N 1  
#SBATCH -n 5
#SBATCH --mem=50G
#SBATCH -t 00:00:00               
#SBATCH --array=1-9


SAMPLE=$(cat /syn1/liangzhen/jinhua_jilab_project/data/bulkATAC/Data/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)
SAMPLENAME=`basename ${SAMPLE}`

export LD_LIBRARY_PATH=/home/liangzhen/anaconda3/envs/carta/lib:$LD_LIBRARY_PATH


cd /syn1/liangzhen/jinhua_jilab_project/result/bulkATAC/bowtie2
#/home/liangzhen/anaconda3/envs/cnvkit/bin/bowtie2 --local --very-sensitive --no-mixed --no-discordant  -x /syn1/liangzhen/juanzhen_emt_tfseq_project/data/bulkATAC/reference/mm10 -1 /syn1/liangzhen/jinhua_jilab_project/data/bulkATAC/Data/CleanData/${SAMPLE}/${SAMPLE}.CleanData.R1.fastq.gz -2 /syn1/liangzhen/jinhua_jilab_project/data/bulkATAC/Data/CleanData/${SAMPLE}/${SAMPLE}.CleanData.R2.fastq.gz -p 5 | /opt/software/samtools-1.12/samtools view -bS - > ${SAMPLENAME}.bam

#/opt/software/samtools-1.12/samtools sort ${SAMPLENAME}.bam -o ${SAMPLENAME}_sorted.bam 
#/opt/software/samtools-1.12/samtools index ${SAMPLENAME}_sorted.bam

/home/liangzhen/anaconda3/envs/topact/bin/bamCoverage --numberOfProcessors 5 --normalizeUsing RPGC --bam ${SAMPLENAME}_sorted.bam -o ${SAMPLENAME}_coverage_RPGC.bw  --binSize 10 --effectiveGenomeSize 2652783500
