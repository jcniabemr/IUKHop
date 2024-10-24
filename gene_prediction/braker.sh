#!/usr/bin/env bash
#SBATCH -J braker
#SBATCH --partition=long
#SBATCH --mem-per-cpu=6G
#SBATCH --cpus-per-task=14

source activate brakerGenePred

export PATH="$PATH:/mnt/shared/scratch/jconnell/apps/hdf5/bin"
export PATH="$PATH:/mnt/shared/scratch/jconnell/apps/hal/hal/bin"
export PATH="$PATH:/mnt/shared/scratch/jconnell/apps/USCS_tools/"

Assembly=${1}
OutDir=${2}
geneModelName=${3}

cp $Assembly ${TMPDIR}/assembly.fa
cd ${TMPDIR}


/mnt/shared/scratch/jconnell/apps/BRAKER/BRAKER-2.1.6/scripts/braker.pl \
  --AUGUSTUS_CONFIG_PATH=/mnt/shared/scratch/jconnell/apps/Augustus/config \
  --AUGUSTUS_BIN_PATH=/mnt/shared/scratch/jconnell/apps/Augustus/bin \
  --AUGUSTUS_SCRIPTS_PATH=/mnt/shared/scratch/jconnell/apps/Augustus/scripts \
  --BAMTOOLS_PATH=/mnt/shared/scratch/jconnell/apps/bamtools/bin \
  --GENEMARK_PATH=/mnt/destiny/sandbox/jconnell/geneMark/gmes_linux_64_4 \
  --SAMTOOLS_PATH=/mnt/shared/scratch/jconnell/samtools/samtools-1.19.2 \
  --PROTHINT_PATH=/mnt/shared/scratch/jconnell/apps/ProtHint/ProtHint-2.6.0/bin \
  --ALIGNMENT_TOOL_PATH=/home/jconnell/miniconda3/pkgs/spaln-2.4.7-pl5262h9a82719_0/bin \
  --DIAMOND_PATH=/home/jconnell/miniconda3/pkgs/diamond-0.9.14-h2e03b76_4/bin \
  --BLAST_PATH=/home/jconnell/miniconda3/envs/brakerGenePred/bin \
  --PYTHON3_PATH=/home/jconnell/miniconda3/envs/brakerGenePred/bin \
  --JAVA_PATH=/home/jconnell/miniconda3/bin \
  --GUSHR_PATH=/mnt/shared/scratch/jconnell/apps/GUSHR/GUSHR \
  --MAKEHUB_PATH=/home/jconnell/miniconda3/pkgs/makehub-1.0.5-1/bin \
  --CDBTOOLS_PATH=/home/jconnell/miniconda3/envs/brakerGenePred/bin \
  --overwrite \
  --gff3 \
  --softmasking on \
  --species=${geneModelName} \
  --genome="assembly.fa" \

cp -r braker/* $OutDir

conda deactivate 
sbatch /mnt/shared/home/jconnell/git_repos/niab_repos/genePredictionPipeline/brakerMakerCodingQuarry.sh bedtoolsIntersect
