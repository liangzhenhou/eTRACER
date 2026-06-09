#!/bin/bash

#SBATCH -J annovar
#SBATCH -o /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/annovar.out       
#SBATCH -e /syn1/liangzhen/jinhua_jilab_project/result/WES/shell/annovar.error
#SBATCH -p all
#SBATCH -N 1                      # apply for one node
#SBATCH -n 15
#SBATCH --mem=20G
#SBATCH -t 00:00:00                # time limitation
#SBATCH --array=1-9

sample=$(cat /syn1/liangzhen/jinhua_jilab_project/result/WES/sample.list | sed -n ${SLURM_ARRAY_TASK_ID}p)


cd /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect
source /data/xieduo/WES_pipe/pipeline/bin/Miniconda3/bin/activate gatk_4.2.6.1

/data/xieduo/WES_pipe/pipeline/bin/annovar/convert2annovar.pl -format vcf4 /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.vcf  -outfile ${sample}_somatic.snv.filter.PASS -allsample -includeinfo  

/data/xieduo/WES_pipe/pipeline/bin/annovar/table_annovar.pl /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.avinput /syn1/liangzhen/GATK_mm10_resource/mousedb -buildver mm10 -out /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.annovar -remove -protocol refGene -operation g -nastring NA

mv /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.annovar.mm10_multianno.txt /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.annovar


#echo -e "EP2N_cover\tEP2N_alt_freq" > ${sample}_somatic.snv.filter.PASS.annovar.tmp  
#/data/xieduo/WES_pipe/pipeline/bin/vcftools-0.1.16/bin/vcf-query -c EP2N -f '[%DP\t%AD\t]\n' /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.vcf | sed 's/\,/\'$'\t/g' | awk '{print $1"\t"$3/($1+1)}' >>${sample}_somatic.snv.filter.PASS.annovar.tmp  

echo -e "${sample}_cover\t${sample}_ref_count\t${sample}_alt_count\t${sample}_alt_freq" > ${sample}_somatic.snv.filter.PASS.${sample}.tmp
/data/xieduo/WES_pipe/pipeline/bin/vcftools-0.1.16/bin/vcf-query -c ${sample} -f '[%DP\t%AD\t]\n' /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.vcf | sed 's/\,/\'$'\t/g' | awk '{print $1"\t"$2"\t"$3"\t"$3/($1+1)}' >> ${sample}_somatic.snv.filter.PASS.${sample}.tmp 

#paste ${sample}_somatic.snv.filter.PASS.annovar.tmp ${sample}_somatic.snv.filter.PASS.${sample}.tmp > ${sample}_somatic.snv.filter.PASS.annovar.tmp1 && mv ${sample}_somatic.snv.filter.PASS.annovar.tmp1 ${sample}_somatic.snv.filter.PASS.annovar.tmp
paste ${sample}_somatic.snv.filter.PASS.${sample}.tmp > ${sample}_somatic.snv.filter.PASS.annovar.tmp1 && mv ${sample}_somatic.snv.filter.PASS.annovar.tmp1 ${sample}_somatic.snv.filter.PASS.annovar.tmp

cut -f 1-5 /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.annovar > /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.tmp1 && cut -f 6- /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.annovar > /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.tmp3 && paste /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.tmp1  /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.annovar.tmp /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.${sample}.tmp3 > /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.annovar.all

 awk '{ if($6 >= 10) { print }}' /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.annovar.all > /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS.annovar.all.txt && rm -f /syn1/liangzhen/jinhua_jilab_project/result/WES/results/2.Mutect/${sample}_somatic.snv.filter.PASS*tmp*
