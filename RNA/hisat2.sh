#!/bin/bash
#SBATCH -J hisat2                   
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/bulk_RNA/hisat2.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/bulk_RNA/hisat2.error
#SBATCH -p all
#SBATCH -N 1  
#SBATCH -n 4 
#SBATCH --mem=10G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-3


SAMPLE=$(cat /syn1/liangzhen/jinhua_jilab_project/data/EPC_bulkRNA/clean_data/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)
SAMPLENAME=`basename ${SAMPLE}`


OUTDIR="/syn1/liangzhen/jinhua_jilab_project/data/EPC_bulkRNA/hisat2"
/home/liangzhen/anaconda3/envs/hisat2/bin/hisat2 -p 4 -x /syn1/liangzhen/fanli_tfseq_project/hisat2_index/grcm38_tran/genome_tran -1 ${SAMPLE}_1_clean.fq.gz -2 ${SAMPLE}_2_clean.fq.gz -S ${OUTDIR}/${SAMPLENAME}.sam

/opt/software/samtools-1.12/samtools view -bS ${OUTDIR}/${SAMPLENAME}.sam > ${OUTDIR}/${SAMPLENAME}.bam
/opt/software/samtools-1.12/samtools sort -@ 4 ${OUTDIR}/${SAMPLENAME}.bam -o ${OUTDIR}/${SAMPLENAME}.sorted.bam
/opt/software/samtools-1.12/samtools index ${OUTDIR}/${SAMPLENAME}.sorted.bam

rm ${OUTDIR}/${SAMPLENAME}.sam ${OUTDIR}/${SAMPLENAME}.bam


