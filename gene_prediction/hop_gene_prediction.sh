#!/usr/bin/env bash
#SBATCH --partition long
#SBATCH -J iUKHop
#SBATCH --cpus-per-task=12
#SBATCH --mem=100G
#SBATCH --mail-user=john.connell@niab.com
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/mnt/shared/projects/niab/iUKHop/hopGenePrediction.out

####Set paths 
genomeAssembly=/mnt/shared/projects/niab/iUKHop/reference/newReference/dovetailCascade10ScaffoldsUnmasked.fasta
outdir=/mnt/shared/projects/niab/iUKHop/genePrediction 
progDir=/mnt/shared/home/jconnell/git_repos/niab_repos/iUKHop/gene_prediction

####Run tools 
braker(){
geneModelName=$(echo $(basename ${genomeAssembly} .fasta)_$(date | sed 's/[ :]/_/g'))
echo ${geneModelName}
mkdir -p ${outdir}/braker
sbatch ${progDir}/braker.sh ${genomeAssembly} ${outdir}/braker ${geneModelName}
}

# bedtoolsIntersect(){
# brakerPredictions=${outdir}/braker/augustus.hints.gff3
# python ${progDir}/removeErrorCDS.py --gff ${outdir}/combinedPredictions/tmp/codingQuarryBrakerIntersection.gff
# python ${progDir}/removeDupliatedGFFlines.py --gff ${outdir}/braker/augustus.hints.gff3
# python ${progDir}/sortCodingQuarryBraker.py --gff ${outdir}/combinedPredictions/tmp/codingQuarryBrakerIntersection_CDS_sorted_AddedFeatures.gff3 ${outdir}/braker/augustus.hints_duplicates_removed.gff
# mv Sorted_renamed_genes.gff $(echo $(basename ${genomeAssembly%.*}).gff)
# rm -r ${outdir}/combinedPredictions 
# python ${progDir}/createCDS.py --gff ${outdir}/*.gff --fasta ${genomeAssembly} --strainName $(basename ${genomeAssembly%.*})
# }

if [ -z ${1} ]; then 
	braker 
elif [ ${1} == "bedtoolsIntersect" ]; then 
		bedtoolsIntersect	 	
else 
	exit 1
fi 