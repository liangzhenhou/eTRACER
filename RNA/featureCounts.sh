#!/bin/bash
#SBATCH -J featureCounts                   
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/bulk_RNA/featureCounts.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/bulk_RNA/featureCounts.error
#SBATCH -p all
#SBATCH -N 1  
#SBATCH -n 10                   
#SBATCH --mem=10G
#SBATCH -t 00:00:00                # time limitation


/home/liangzhen/anaconda3/envs/Subread/bin/featureCounts -T 10 -p -B -C -t exon -g gene_name -a /syn1/liangzhen/fanli_tfseq_project/hisat2_index/Mus_musculus.GRCm38.84.gtf.gz -o /syn1/liangzhen/jinhua_jilab_project/data/EPC_bulkRNA/featureCounts/featureCounts.txt /syn1/liangzhen/jinhua_jilab_project/data/EPC_bulkRNA/hisat2/*.sorted.bam

