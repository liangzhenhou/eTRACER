#!/bin/bash
#SBATCH -J GRN
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/script/SCRNA/log/GRN.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/script/SCRNA/log/GRN.error
#SBATCH -p fat
#SBATCH -N 1               
#SBATCH -n 10
#SBATCH --mem=50G
#SBATCH -t 00:00:00  


cd /syn1/liangzhen/jinhua_jilab_project/result/scRNA/GRN/cluster_all

/home/liangzhen/anaconda3/envs/pyscenic/bin/pyscenic grn --num_workers 10 --output adj.tsv --method grnboost2 adatas.T23.loom ../database/mm_mgi_tfs.txt

/home/liangzhen/anaconda3/envs/pyscenic/bin/pyscenic ctx adj.tsv ../database/mm10_10kbp_up_10kbp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather --annotations_fname ../database/motifs-v10nr_clust-nr.mgi-m0.001-o0.0.tbl --expression_mtx_fname adatas.T23.loom --mode "dask_multiprocessing" --output reg.csv --num_workers 10 --mask_dropouts

/home/liangzhen/anaconda3/envs/pyscenic/bin/pyscenic aucell adatas.T23.loom reg.csv --output adatas_SCENIC.loom --num_workers 10

