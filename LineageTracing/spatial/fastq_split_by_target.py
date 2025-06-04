
import gzip, time
import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict
import pandas as pd
import seaborn as sns
from Bio.Seq import Seq
from collections import Counter
import os

sample_paths = {
    'r1': {
        'fastq_paths':['/syn1/liangzhen/jinhua_jilab_project/data/DNA_Amplicon/spatial/T2/s2164g01165_MCS-20240908-L-01-2024-09-141719/Sample_SQ24068603-YJH-cas9-79-YJH-cas9-79/SQ24068603-YJH-cas9-79-YJH-cas9-79_combined_{}.fastq.gz']
    },
    'r2': {
        'fastq_paths':['/syn1/liangzhen/jinhua_jilab_project/data/DNA_Amplicon/spatial/T2/s2164g01165_MCS-20240908-L-01-2024-09-212053/Sample_SQ24068604-YJH-cas9-80-YJH-cas9-80/SQ24068604-YJH-cas9-80-YJH-cas9-80_combined_{}.fastq.gz']
    },
    'r3':{
	'fastq_paths':['/syn1/liangzhen/jinhua_jilab_project/data/DNA_Amplicon/spatial/T2/s2164g01174_MCS-20241011-L-02-2024-10-191916/Sample_SQ24075303-YJH-cas9-86-YJH-cas9-86/SQ24075303-YJH-cas9-86-YJH-cas9-86_combined_{}.fastq.gz']
    },
    'r4':{
        'fastq_paths':['/syn1/liangzhen/jinhua_jilab_project/data/DNA_Amplicon/spatial/T2/s2164g01174_MCS-20241011-L-02-2024-10-192101/Sample_SQ24075302-YJH-cas9-85-YJH-cas9-85/SQ24075302-YJH-cas9-85-YJH-cas9-85_combined_{}.fastq.gz']
    }

}

def get_innerBC(r2_line):
    innerBC = r2_line[0:6]
    num_Ns = sum([c=='N' for c in innerBC])
    innerBC_ref = ['AATCCG','AATCGC','AAGTCG','AAGCTC','AACGTG','AACTGC','ATAGCG',
                  'ATTCCG','ATGCCA','ATGTTC','ATCACG','ATCCAG','ACAGTG','ACTCTG','ACTTGA',
                  'ACGATC'] # target gene sequencing index
    if num_Ns > 1: return None 
    elif num_Ns == 1 and innerBC == 'ANTCCG':return None # will miss some reads
    elif num_Ns == 1 and np.any([innerBC.replace('N',c) in innerBC_ref for c in 'ACTG']): 
        return [innerBC.replace('N',c) for c in 'ACTG' if innerBC.replace('N',c) in innerBC_ref ][0]
    elif innerBC in innerBC_ref: return innerBC
    else: return None
    
def hamming(bc1,bc2): return np.sum([x1 != x2 for x1,x2 in zip(bc1,bc2)])



innerBC_reads_count = {}
innerBC_reads_count['r1'] = {}
innerBC_reads_count['r2'] = {}

for sample,paths in sample_paths.items():
    for fastq_path in paths['fastq_paths']:
        R1 = gzip.open(fastq_path.format('R1'))
        R2 = gzip.open(fastq_path.format('R2'))
        counter = 0
        start_time = time.time()
        while True:
            counter += 1
            if counter % 1000000 == 0: print(fastq_path+ ': Processed {} reads in {} seconds'.format(counter, time.time()-start_time))
            try:
                r1_line = R1.readline().decode('utf-8')
                r2_line = R2.readline().decode('utf-8')
            except:
                print('ERROR extracting {}'.format(fastq_path))
                break
            if r2_line == '' : break
            if r2_line[0] == '@': 
                read2_name = r2_line
                read1_name = r1_line
                
                read1_seq = R1.readline().decode('utf-8')
                read2_seq = R2.readline().decode('utf-8')
                
                if get_innerBC(read2_seq)!=None:
                    innerBC = get_innerBC(read2_seq)
                    read2_QI = R2.readline().decode('utf-8')
                    read2_baseQ = R2.readline().decode('utf-8')
                    read2 = [read2_name , read2_seq , read2_QI , read2_baseQ]

                    read1_QI = R1.readline().decode('utf-8')
                    read1_baseQ = R1.readline().decode('utf-8')
                    read1 = [read1_name , read1_seq , read1_QI , read1_baseQ]

                    #print(read1)
                    
                    if innerBC in innerBC_reads_count['r1']:
                        innerBC_reads_count['r1'][innerBC] += read1
                        innerBC_reads_count['r2'][innerBC] += read2
                    else:
                        innerBC_reads_count['r1'][innerBC] = read1
                        innerBC_reads_count['r2'][innerBC] = read2
                else:
                    read2_QI = R2.readline().decode('utf-8')
                    read2_baseQ = R2.readline().decode('utf-8')
                    read2 = [read2_name , read2_seq , read2_QI , read2_baseQ]
                    
                    read1_QI = R1.readline().decode('utf-8')
                    read1_baseQ = R1.readline().decode('utf-8')
                    read1 = [read1_name , read1_seq , read1_QI , read1_baseQ]

                    if 'unclassified' in innerBC_reads_count['r1']:
                        innerBC_reads_count['r1']['unclassified'] += read1
                        innerBC_reads_count['r2']['unclassified'] += read2
                    else:
                        innerBC_reads_count['r1']['unclassified'] = read1
                        innerBC_reads_count['r2']['unclassified'] = read2


os.system('rm /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/fastq/*.fq')
for fq,pooled_reads in innerBC_reads_count.items():
    for innerBC,reads_set in pooled_reads.items():
        #print(innerBC+fq)
        with open('/syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/fastq/'+innerBC+'_'+fq+'.fq','w+') as f:
            f.writelines(reads_set)

os.system('ls /syn1/liangzhen/jinhua_jilab_project/result/DNA_Amplicon/SPATIAL/T2/fastq/*.fq|xargs -I {} gzip {}')

print('finished')

total_count = 0 
for rep in innerBC_reads_count:
    print(rep)
    for innerBC in innerBC_reads_count[rep]:
        print(innerBC+':'+str(len(innerBC_reads_count[rep][innerBC])))
        total_count += len(innerBC_reads_count[rep][innerBC])
    print(total_count)
