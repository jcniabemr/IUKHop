#!/usr/bin/env bash
#SBATCH --partition medium
#SBATCH -J iUKHop
#SBATCH --cpus-per-task=12
#SBATCH --mem=400G
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

###Build reference index for later
# bwa index ${reference}

# ####Begin analysis 
# for x in $(ls ${outDir}/raw_data/*.gz); do
# 	readName=$(basename ${x} .FASTQ.gz) 

# ####Read quality assesment 
# 	mkdir -p ${outDir}/fastqc/${readName}
# 	fastqc \
# 		-t $(nproc) \
# 		-o ${outDir}/fastqc/${readName} \
# 		${x}

# ####Read quality and length filtering 
# 	mkdir -p ${outDir}/filteredReads/${readName}
# 	fastp \
# 		--in1 ${x} \
# 		--out1 ${outDir}/filteredReads/${readName}/${readName}_filtered.fastq \
# 		--json ${outDir}/filteredReads/${readName}/${readName}_filtered.json \
# 		--html ${outDir}/filteredReads/${readName}/${readName}_filtered.html \
# 		--cut_mean_quality 20 \
# 		--length_required 50
#  	filteredRead=${outDir}/filteredReads/${readName}/${readName}_filtered.fastq

# ####Read alignment 
# 	mkdir -p ${outDir}/alignment/${readName}
# 	flowcell=$(grep "@" ${filteredRead} | cut -d ":" -f3 | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
# 	readGroup="@RG\\tID:${readName}.1.${flowcell}\\tPU:${readName}.1.${flowcell}\\tPL:Illumina\\tLB:${readName}.${flowcell}\\tSM:${readName}"
# 	bwa mem \
# 	 	-t $(nproc) \
# 	 	-M \
# 	 	-R ${readGroup} \
# 	 	${reference} \
# 	 	${filteredRead} \
# 	 	| samtools view -b - | samtools fixmate -mc - - | samtools sort - -O 'BAM' -o \
# 	 	${outDir}/alignment/${readName}/${readName}_aligned_sorted.bam
# 	samtools flagstat ${outDir}/alignment/${readName}/${readName}_aligned_sorted.bam > ${outDir}/alignment/${readName}/${readName}_alignmentStats.txt
# done 

# ####Variant calling
# batch=1
# filecount=$(ls ${outDir}/alignment | wc -l)
# for i in $(seq 100 100 $((${filecount}+100))); do 
# 	if [ ${filecount} -gt 100 ]; then
# 		bamList=$(ls ${outDir}/alignment/*/*.bam | head -n ${i} | tail -n 100)
# 	else
# 		bamList=$(ls ${outDir}/alignment/*/*.bam | head -n ${i} | tail -n ${filecount})
# 	fi
# 	filecount=$((filecount-100))
# 	mkdir -p ${outDir}/variantCalling
# 	bcftools mpileup \
# 		-Ou \
# 		--bam-list <(for x in ${bamList}; do echo ${x}; done) \
# 		-q 20 \
# 		-C 50 \
# 		-a AD,DP \
# 		-f ${reference} | bcftools call --ploidy 2 -c -v -Ov > ${outDir}/variantCalling/batch_${batch}_bcfTools_DArTseq_VariantCalls_Raw.vcf
# 	((batch++))
# done 

# ####Merge VCFs
# bcftools merge $(for x in $(ls ${outDir}/variantCalling/*); do bgzip ${x}; tabix ${x}.gz; echo ${x}.gz; done) -Ov -o ${outDir}/variantCalling/raw_concatenated.vcf

####Filter VCF
filterResults(){
outDir=$(echo ${1} | rev | cut -d "/" -f2- | rev)
vcf=$(echo ${1} | rev | cut -d "/" -f1 | rev)
name=$(basename ${vcf} .vcf)
cp ${1} ${TMPDIR}/${vcf}
cd ${TMPDIR}
####FilterQuality for 25percentile and above 
python /mnt/shared/home/jconnell/git_repos/niab_repos/github_bioinformatics_tools/filterVCFdepth.py \
--vcf ${vcf} \
--qual
echo "Qual complete"
####Seperate SNPs
bcftools view -v snps ${name}_AutoQualFilter.vcf -o FilteredQualSNPs.vcf
bcftools view -v indels ${name}_AutoQualFilter.vcf -o removedIndels.vcf
####Create bed exclusion file for filtering around indels  
python /mnt/shared/home/jconnell/git_repos/niab_repos/python_bioinformatics_tools/eragrostis/extract_vcf_info.py \
	-snp FilteredQualSNPs.vcf \
	-indel removedIndels.vcf
echo "INDELs complete"
####Exclude SNPs round INDELs
vcftools \
	--vcf FilteredQualSNPs.vcf \
	--exclude-bed snp_excluson_data.txt \
	--recode \
	--recode-INFO-all \
	--out FilteredQualSNPsINDELloc.vcf
####Filter out triallelic variation
cat FilteredQualSNPsINDELloc.vcf.recode.vcf | awk -F '\t' '{split($5,a,","); if(length(a)<=1) print}' > FilteredQualSNPsINDELlocBi.vcf
echo "Multiallelic complete"
####Depth filter below 95 percentile 
python /mnt/shared/home/jconnell/git_repos/niab_repos/github_bioinformatics_tools/filterVCFdepth.py \
	--vcf FilteredQualSNPsINDELlocBi.vcf \
	--depth \
	--auto
echo "Depth complete"
####Max missing filter
vcftools \
	--vcf FilteredQualSNPsINDELlocBi_AutoDepthFilter.vcf \
	--minDP 3 \
	--max-missing 0.1 \
	--recode \
	--recode-INFO-all \
	--out FilteredQualSNPsINDELlocBiAutoDepthFilterMM30_MD3 
echo "Max missing complete"
####Allele frequency filter
python /mnt/shared/home/jconnell/git_repos/niab_repos/iUKHop/genotyping/count_AF.py \
	--vcf FilteredQualSNPsINDELlocBiAutoDepthFilterMM30_MD3.recode.vcf 
mv FilteredQualSNPsINDELlocBiAutoDepthFilterMM30_MD3.recode_AF5.vcf  ${outDir}/CompleteFiltered.vcf
}


filterResults ${outDir}/variantCalling/raw_concatenated.vcf


####Create CM plot 
# createCMPlot(){
# # python  \
# # 	--vcf ${1} \
# # 	--target Scaffold_77
# Rscript /mnt/shared/home/jconnell/git_repos/niab_repos/iUKHop/genotyping/CMplot.R \
# 	--table ${1/.vcf/_CMplot_table.txt}
# }

#createCMPlot ${outDir}/variantCalling/raw_concatenated.vcf