#!/bin/bash
#SBATCH -J cutadapt                   # work name test
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/bulk_RNA/cutadapt.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/bulk_RNA/cutadapt.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 1
#SBATCH --mem=5G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-3

SAMPLENAME=$(cat /syn1/liangzhen/jinhua_jilab_project/data/EPC_bulkRNA/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)
SAMPLENAME_BASENAME=`basename ${SAMPLENAME}`

OUTDIR="/syn1/liangzhen/jinhua_jilab_project/data/EPC_bulkRNA/clean_data"

/home/liangzhen/anaconda3/envs/cutadaptenv/bin/cutadapt -q 20 --max-n 0.1 -a GATCGGAAGAGCACACGTCTGAACTCCAGTCACGGATGACTATCTCGTATGCCGTCTTCTGCTTG -A AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT  -m 50  -o ${OUTDIR}/${SAMPLENAME_BASENAME}_1_clean.fq.gz -p ${OUTDIR}/${SAMPLENAME_BASENAME}_2_clean.fq.gz ${SAMPLENAME}.R1.fastq.gz ${SAMPLENAME}.R2.fastq.gz


