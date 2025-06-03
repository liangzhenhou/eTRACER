#!/bin/bash
#SBATCH -J ST_BarcodeMap_staticBC
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/T2/log/ST_BarcodeMap_staticBC.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/T2/log/ST_BarcodeMap_staticBC.error
#SBATCH -p all
#SBATCH -N 1                      
#SBATCH -n 1
#SBATCH --mem=20G
#SBATCH -t 00:00:00  
#SBATCH --array=17

gene_index=$(cat /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/fastq/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)


export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/liangzhen/anaconda3/envs/R432/lib:/home/liangzhen/anaconda3/envs/ST_BarcodeMap/lib

# r1
cd /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/fastq
/home/liangzhen/tools/ST_BarcodeMap/ST_BarcodeMap-0.0.1 --in /syn1/liangzhen/jinhua_jilab_project/data/spatial/sunyannan0626024/X101SC24045330-Z01-J002_StereoSeq_release_20240625095526/Rawdata/YJH_ST_2/B03203C612.barcodeToPos.h5 --in1 ${gene_index}_r1.fq.gz --in2 ${gene_index}_r1.fq.gz --out ${gene_index}_mapped_r1.fq.gz   --mismatch 1 --thread 1 --barcodeStart 36 --barcodeLen 25 --umiStart 76 --umiLen 10 

# r2
/home/liangzhen/tools/ST_BarcodeMap/ST_BarcodeMap-0.0.1 --in /syn1/liangzhen/jinhua_jilab_project/data/spatial/sunyannan0626024/X101SC24045330-Z01-J002_StereoSeq_release_20240625095526/Rawdata/YJH_ST_2/B03203C612.barcodeToPos.h5 --in1 ${gene_index}_r1.fq.gz --in2 ${gene_index}_r2.fq.gz --out ${gene_index}_mapped_r2.fq.gz --mismatch 1 --thread 1 --barcodeStart 36 --barcodeLen 25 --umiStart 76 --umiLen 10           
