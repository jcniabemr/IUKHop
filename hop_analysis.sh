#!/usr/bin/env bash
#SBATCH --partition long
#SBATCH -J iUKHop
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --mail-user=john.connell@niab.com
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/mnt/shared/projects/niab/iUKHop/hopAnalysisRunRecord.txt

####Notes
# Raw sequences from DArT-Seq come adapter and barcode trimmed as of 16/8/23 and therefore no adpater trimming will be peformed here. 

#### 1.) Begin analysis 
outDir=/mnt/shared/projects/niab/iUKHop
source activate fastqc
for x in $(ls ${outDir}/raw_data/*); do
	readName=$(basename ${x} .FASTQ.gz) 

####Read quality assesment 
	mkdir -p ${outDir}/fastqc/${readName}
	fastqc \
		-t $(nproc) \
		-o ${outDir}/fastqc/${readName} \
		${x}
	conda deactivate 

####Read quality and length trimming
	source activate trimgalore 
	mkdir -p ${outDir}/trimmedReads/${readName}
	trim_galore \
		-q 20 \
		--length 50 \
		--output_dir ${outDir}/trimmedReads/${readName} \
		${x}
	conda deactivate
	break
done 

#### 2.) Collect barcode info 
sample = readname 
barcode = -1
flowcell = 3
lane = 4
