#!/bin/bash

input=$1
parse_script=$2

tablespace=( "17" "19" )
flush_type=( "0" "1" "2" )

for i in "${tablespace[@]}"
do
    # extract the info of leaf pages
    echo "Extract leaf pages for tablespace ${i}"
    grep "(${i}, " ${input}.txt > ${input}-${i}.txt
    grep "leaf: 1" ${input}-${i}.txt > ${input}-${i}-leaf.txt

    for j in "${flush_type[@]}"
    do
        echo "Separate pages based on their page type (${j})"
        grep "flush-type: ${j}" ${input}-${i}-leaf.txt > ${input}-${i}-leaf-${j}.txt
        awk '{ print $1, $7, $12 - $14, $24 }' ${input}-${i}-leaf-${j}.txt > ${input}-${i}-leaf-${j}-test.txt
        sort -k 2 ${input}-${i}-leaf-${j}-test.txt > ${i}-leaf-${j}-test.txt

        echo "Parse the detailed info for tablespace ${i} / page type ${j}"
        ./${parse_script} ${i}-leaf-${j}-test.txt > ${i}-leaf-${j}-test-result.txt

        echo "Remove temporary files"
        rm ${input}-${i}-leaf-${j}.txt ${input}-${i}-leaf-${j}-test.txt ${i}-leaf-${j}-test.txt
    done
    echo
done