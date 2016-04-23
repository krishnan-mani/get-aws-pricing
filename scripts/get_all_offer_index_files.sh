#!/usr/bin/env bash

SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Error: one or more missing arguments"
	echo "Usage: ${SCRIPT_NAME} offers-file" 
	echo "Run ./read_offer_info.py > offers to get an offers-file"
	exit 1
fi

OFFERS_FILE="$1"

while read line
do
	offer_code=$(echo ${line} | awk '{print $1}')
        offer_code_index_file_url=$(echo ${line} | awk '{print $NF}')
	index_output_file="${offer_code}_offer-index.json"
        wget "${offer_code_index_file_url}" -O "../resources/${index_output_file}"
done < "${OFFERS_FILE}"
