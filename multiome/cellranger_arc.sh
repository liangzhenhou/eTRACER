#!/bin/bash
#SBATCH -J cellranger-arc
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/scATAC_and_scRNA/cellranger-arc.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/scATAC_and_scRNA/cellranger-arc.error
#SBATCH -p all
#SBATCH -N 1               
#SBATCH -n 24
#SBATCH --mem=100G
#SBATCH -t 00:00:00                


cd /syn1/liangzhen/jinhua_jilab_project/result/scATAC_and_scRNA
/syn1/liangzhen/10X_resource/software/cellranger-arc-2.0.2/bin/cellranger-arc count --id=scATAC_and_scRNA --reference=/syn1/liangzhen/10X_resource/reference/mouse/refdata-cellranger-arc-mm10-2020-A-2.0.0 --libraries=/syn1/liangzhen/jinhua_jilab_project/data/scATAC_and_scRNA/LBFC20230372-59and62/libraries.csv --localcores=24 --localmem=100
