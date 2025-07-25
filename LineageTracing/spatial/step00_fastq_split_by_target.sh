#!/bin/bash

#SBATCH -J EE_target_split
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/EE/log/EE_target_split.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/EE/log/EE_target_split.error
#SBATCH -p all
#SBATCH -w node2
#SBATCH -N 1                      # apply for one node
#SBATCH -n 2
#SBATCH --mem=500G
#SBATCH -t 00:00:00                # time limitation

/home/liangzhen/anaconda3/envs/cassiopeia2/bin/python3.8 /syn1/liangzhen/jinhua_jilab_project/script/SPATIAL/EE/fastq_split_by_target.py
