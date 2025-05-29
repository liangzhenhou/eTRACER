library(Seurat)
library(spacexr)
library(ggplot2)

sc.all.merge <- readRDS('/syn1/liangzhen/jinhua_jilab_project/result/scRNA/cellranger/sc.all.merge.T1T2T3a.harmony.final.refine.rds')
sc.all.merge@meta.data$seurat_clusters <- as.character(sc.all.merge@meta.data$seurat_clusters_rename)
sc.all.merge <- JoinLayers(sc.all.merge)

immune <- readRDS('/syn1/liangzhen/jinhua_jilab_project/result/scRNA/cellranger/immune.rds')
immune <- subset(immune,cells = rownames(immune@meta.data)[!immune@meta.data$celltype %in% c('B_cell')])
immune@meta.data$seurat_clusters <- immune@meta.data$celltype


fibroblast <- readRDS('/syn1/liangzhen/jinhua_jilab_project/result/scRNA/cellranger/Fibroblast_BL.rds')
fibroblast@meta.data$seurat_clusters <- 'Fibroblast'

endothelial <- readRDS('/syn1/liangzhen/jinhua_jilab_project/result/scRNA/cellranger/endothelial.rds')
endothelial@meta.data$seurat_clusters <- 'endothelial'

sc.all <- merge(x=sc.all.merge,y=list(immune,fibroblast,endothelial),add.cell.ids = c('tumor','immune','fibroblast','endothelial'))
sc.all <- JoinLayers(sc.all)

# set up reference
Idents(sc.all) <- sc.all@meta.data$seurat_clusters

# extract information to pass to the RCTD Reference function
counts <- sc.all[["RNA"]]$counts
cluster <- as.factor(sc.all@meta.data$seurat_clusters)
names(cluster) <- colnames(sc.all)
nUMI <- sc.all$nCount_RNA
names(nUMI) <- colnames(sc.all)
reference <- Reference(counts, cluster,nUMI)

spatial <- readRDS('/syn1/liangzhen/jinhua_jilab_project/result/SPATIAL/T2/bin50_seurat.rds')
# set up query with the RCTD function SpatialRNA
counts <- spatial[["RNA"]]$counts
coords <- spatial@meta.data[,c("x", "y")]
coords[is.na(colnames(coords))] <- NULL
query <- SpatialRNA(coords, counts, colSums(counts))

#RCTD <- create.RCTD(query, reference, max_cores = 8)
#RCTD <- run.RCTD(RCTD, doublet_mode = 'doublet')
#saveRDS(RCTD,'/syn1/liangzhen/jinhua_jilab_project/result/SPATIAL/T2/RCTD_results_doublet.rds')

#RCTD <- create.RCTD(query, reference, max_cores = 8)
#RCTD <- run.RCTD(RCTD, doublet_mode = 'full')
#saveRDS(RCTD,'/syn1/liangzhen/jinhua_jilab_project/result/SPATIAL/T2/RCTD_results_full.rds')

RCTD <- create.RCTD(query, reference, max_cores = 8)
RCTD <- run.RCTD(RCTD, doublet_mode = 'multi')
saveRDS(RCTD,'/syn1/liangzhen/jinhua_jilab_project/result/SPATIAL/T2/RCTD_results_multi.rds')

