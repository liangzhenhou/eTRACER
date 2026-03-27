#!/bin/bash
#SBATCH -J cellranger
#SBATCH -o /data/liangzhen/jinhua_jilab_project/script/log/cellranger_%j.out       
#SBATCH -e /data/liangzhen/jinhua_jilab_project/script/log/cellranger_%j.error
#SBATCH -p all
#SBATCH -N 1               
#SBATCH -n 24
#SBATCH --mem=100G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1


startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`
################################


WORKDIR='/data/liangzhen/jinhua_jilab_project/result/scRNA/cellranger'
FASTQDIR='/data/liangzhen/jinhua_jilab_project/data/scRNA/230715_A00838_0920_BHFHJFDSX7'
cd $WORKDIR

sample=$(cat /data/liangzhen/jinhua_jilab_project/data/scRNA/230715_A00838_0920_BHFHJFDSX7/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)
SRA=${sample}

/data/zhaolian/software/cellranger-7.1.0/bin/cellranger count --id=${sample} --localcores=24 --transcriptome=/data/liangzhen/10X_resource/reference/mouse/refdata-gex-mm10-2020-A --fastqs=${FASTQDIR} --sample=${SRA}

/opt/software/samtools-1.12/samtools sort -t CB -O BAM -o ./${sample}/outs/cellsorted_possorted_genome_bam.bam ./${sample}/outs/possorted_genome_bam.bam 

/home/liangzhen/anaconda3/bin/velocyto run10x ./${sample}  /data/liangzhen/10X_resource/reference/mouse/refdata-gex-mm10-2020-A/genes/genes.gtf

#################################
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`

sumTime=$[ $endTime_s - $startTime_s ]

echo "$startTime ---> $endTime" "Total:$sumTime seconds"

