#!/bin/bash

mkdir -p /root/topic

#Check command line parameters
if [ "$#" -ne 1 ]; then
    echo "Usage: ./split_lines.sh <input_file>"
    exit 1
fi

#Get input file name
input_file="$1"


#Counter used to generate output file names
counter=1

#Row counter
line_counter=0

#Loop through each line of the input file
while IFS= read -r line; do
    #Calculate output file name
    output_file="/root/topic/output_file_$counter"

    #Write lines to output file
    echo "$line" >> "$output_file"

    #Update row counter
    line_counter=$((line_counter + 1))

    #Update the file counter and reset the line counter every 5 lines
    if [ $line_counter -eq 5 ]; then
        counter=$((counter + 1))
        line_counter=0
    fi
done < "$input_file"
