#!/usr/bin/env bash
#SBATCH --partition long
#SBATCH -J iUKHop
#SBATCH --cpus-per-task=12
#SBATCH --mem=100G
#SBATCH --mail-user=john.connell@niab.com
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/mnt/shared/projects/niab/iUKHop/hopAnalysisRunRecord.out

####Notes
# Raw sequences from DArT-Seq come adapter and barcode trimmed as of 16/8/23 and therefore no adpater trimming will be peformed here. 
####

####Set paths 
source activate hop_analysis
outDir=/mnt/shared/projects/niab/iUKHop
reference=/mnt/shared/projects/niab/iUKHop/reference/newReference/dovetailCascade10ScaffoldsUnmasked.fasta

####Begin analysis 
for x in $(ls ${outDir}/raw_data/*.gz); do
	readName=$(basename ${x} .FASTQ.gz) 

####Read quality assesment 
	mkdir -p ${outDir}/fastqc/${readName}
	fastqc \
		-t $(nproc) \
		-o ${outDir}/fastqc/${readName} \
		${x}

####Read quality and length filtering 
	mkdir -p ${outDir}/filteredReads/${readName}
	fastp \
		--in1 ${x} \
		--out1 ${outDir}/filteredReads/${readName}/${readName}_filtered.fastq \
		--json ${outDir}/filteredReads/${readName}/${readName}_filtered.json \
		--html ${outDir}/filteredReads/${readName}/${readName}_filtered.html \
		--cut_mean_quality 20 \
		--length_required 50
	filteredRead=${outDir}/filteredReads/${readName}/${readName}_filtered.fastq

####Read alignment 
	mkdir -p ${outDir}/alignment/${readName}
	flowcell=$(grep "@" ${filteredRead} | cut -d ":" -f3 | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
	readGroup="@RG\\tID:${readName}.1.${flowcell}\\tPU:${readName}.1.${flowcell}\\tPL:Illumina\\tLB:${readName}.${flowcell}\\tSM:${readName}"
	bwa mem \
	 	-t $(nproc) \
	 	-M \
	 	-R ${readGroup} \
	 	${reference} \
	 	${filteredRead} \
	 	| samtools view -b - | samtools fixmate -mc - - | samtools sort - -O 'BAM' -o \
	 	${outDir}/alignment/${readName}/${readName}_aligned_sorted.bam
	samtools flagstat ${outDir}/alignment/${readName}/${readName}_aligned_sorted.bam > ${outDir}/alignment/${readName}/${readName}_alignmentStats.txt
done 

####Variant calling 
mkdir -p ${outDir}/variantCalling
bcftools mpileup \
-Ou \
--bam-list <(for x in $(ls ${outDir}/alignment/*/*bam); do echo ${x}; done) \
-q 20 \
-C 50 \
-a AD,DP \
-f ${reference} | bcftools call --ploidy 2 -c -v -Ov > ${outDir}/variantCalling/bcfToolsDArTseqVariantCallsRaw.vcf

# ####Create CM plot 
# python /mnt/shared/home/jconnell/git_repos/niab_repos/iUKHop/CMplot.py \
# 	--vcf ${outDir}/variantCalling/bcfToolsDArTseqVariantCallsRaw.vcf \
# 	--reference ${reference}

