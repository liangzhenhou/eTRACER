#!/bin/bash

#SBATCH -J iqtree2
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/multiome/log/iqtree2.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/AMPLICON/multiome/log/iqtree2.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 5
#SBATCH --mem=300G
#SBATCH -t 00:00:00                # time limitation



cd /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/trees/multiome
/home/kantian/miniconda3/envs/smalt/bin/iqtree2 -s /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/trees/multiome/multiome-401.phy -o 'synthetic' --polytomy
