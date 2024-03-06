#!/bin/bash

# Test pipeline with the provided data
# Akiris Moctezuma Jul 2023 
# https://github.com/PacificBiosciences/pb-16S-nf

# Updates to nextflow.config:
# process {
#   executor = 'pbspro'
#   maxForks = '1'
#   queue = 'three_hour'
#   time = '3h'
#   clusterOptions = { "-M Akiris.Moc.901@cranfield.ac.uk" }
#   module = 'Singularity/2.6.1-GCC-5.4.0-2.26'
# }

# Updates to this script:
# - source bashrc to initialise conda
# - activate conda environment with nf
# - Started the pipeline in the dedicated results SUB- folder
# - Added these options to the pipeline call: 
#   --outdir results \
#   --adapter_p RGYTACCTTGTTACGACTT \
#   --dada2_cpu 8 \
#   --vsearch_cpu 8 \
#   --cutadapt_cpu 8 #\

# Note: this script should be run on a compute node
# qsub s01_analysis_Zymo_FL16S.sh

# PBS directives
#---------------

#PBS -N s01_analysis_Zymo_FL16S
#PBS -l nodes=1:ncpus=16
#PBS -l walltime=06:00:00
#PBS -q six_hour 
#PBS -m abe 
#PBS -M Akiris.Moc.901@cranfield.ac.uk 

#===============
#PBS -j oe
#PBS -W sandbox=PRIVATE
#PBS -k n
ln -s $PWD $PBS_O_WORKDIR/$PBS_JOBID
## Change to working directory
cd $PBS_O_WORKDIR
## Calculate number of CPUs
export cpus=`cat $PBS_NODEFILE | wc -l`
## =============

# Start message
echo "Started"
date
echo ""

# Stop at runtime errors
set -e

# Initialise conda
# module load Miniconda3/4.11.0
# conda init bash
source ~/.bashrc

# Activate conda environment with thesis
conda activate thesis

# Load Singularity module
module load Singularity/2.6.1-GCC-5.4.0-2.26
echo "Singularity version: "
singularity --version
echo ""

# The start folder
project_folder="/scratch/s394901/thesis"
mkdir -p "${project_folder}"/results/analysis_Zymo_FL16S
cd "${project_folder}"/results/analysis_Zymo_FL16S

# Run pipeline with test data
nextflow run "${project_folder}"/tools/pb-16S-nf/main.nf \
--input "${project_folder}"/data/data_callahan_2019/sample.tsv \
--metadata "${project_folder}"/data/data_callahan_2019/metadata.tsv \
--outdir callahan_Zymo \
--adapter_p RGYTACCTTGTTACGACTT \
--dada2_cpu 16 \
--vsearch_cpu 16 \
--cutadapt_cpu 16 \
-profile singularity

# Completin message
echo "Done"
date

# --- Your code ends here --- #

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
