#!/bin/bash

# Generate QC reports of yan_2023 dataset (trimmed) using FastQC
# Akiris Moctezuma  Jul 2023

# Note: this script should be run on a compute node
# qsub s06_qc_yan_2023_trimmed.sh

# PBS directives
#---------------

#PBS -N s06_qc_yan_2023_trimmed
#PBS -l nodes=1:ncpus=4
#PBS -l walltime=00:30:00
#PBS -q half_hour
#PBS -m abe
#PBS -M akiris.moc.901@cranfield.ac.uk

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

# Stop at runtime errors
set -e

# Load required modules
module load FastQC/0.11.8-Java-1.8.0_92

# Start message
echo "FastQC"
date
echo ""

# Use FastQC
# Folders
base_folder="/scratch/s394901/thesis"
data_folder="${base_folder}/data/data_yan_2023_trimmed_primers" 

# Go to data folder
cd "${data_folder}"

# List of files in data folder
fastq_files=$(ls *.fastq*)

# Run FastQC for all fastq files
fastqc $fastq_files 

# Completion message
echo "Done"
date

# --- Your code ends here --- #

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
