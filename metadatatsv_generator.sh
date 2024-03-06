#!/bin/bash

# Akiris Moctezuma Jul 2023
# Generates the metadata.tsv file, takes as input the samples.txt file

# samples.txt is the file with all the sample information of a specific dataset 
# Note: this script should be executed directly on the command line 




# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 samples.txt"
    exit 1
fi


# Get the input file path from the command-line argument
input_file=$1

# Extract the file name from the input file path
input_filename=$(basename "$input_file")

# Define the output file name
output_file="metadata.tsv"

# Define the columns names
echo -e "sample_name\tcondition" >> "$output_file"

# Save the third and fourth columns to the new file  
awk -F'\t' 'NR > 1 { print $3 "\t" $4 }' "$input_file" >> "$output_file"

# Completion message
echo "Done"
echo "Input file name: $input_filename"
echo "Output file name: $output_file"
