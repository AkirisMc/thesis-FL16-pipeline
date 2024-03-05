#!/bin/bash

# Download yan_2023 dataset from the SRA 
# Akiris Moctezuma  Jul 2023

# Note: this script should be run on a compute node
# qsub s03_get_data_yan_2023.sh

# PBS directives
#---------------

#PBS -N s03_get_data_yan_2023
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

# Start message
echo "Downloading files from SRA"
date
echo ""

## Download source data from SRA
# Folders
base_folder="/scratch/s394901/thesis"
sra_folder="${base_folder}/tools/sratoolkit.3.0.0-ubuntu64/bin"
data_folder="${base_folder}/data/data_yan_2023" 

# Go to data folder
cd "${data_folder}"

# List SRA IDs 
# (the next line reads the second column from the samples_yan_2023.txt file, omitting the header line)
sra_ids=$(awk 'NR > 1 {print $2}' samples_yan_2023.txt)

# Loop over SRA IDs and use fasterq-dump to download the data
for id in $sra_ids
do
  echo "${id}"
  "${sra_folder}/fasterq-dump" $id --split-files --skip-technical --outdir "${data_folder}"
  echo ""
done

# Completion message
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
