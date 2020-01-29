#!/bin/bash

buf_size=( "10G" "20G" "30G" "40G" "50G" )
anal_type=( "origin" "war" )

for i in "${anal_type[@]}"
do
    for j in "${buf_size[@]}"
    do
        grep "nvme" ${j}_1024_iostat_${i}.out > ${j}_1024_iostat_${i}_extract.out

        echo "${i}/${j} r/s"
        awk '{ sum += $4; n++ } END { if (n > 0) print sum / n;}' ${j}_1024_iostat_${i}_extract.out
        echo "${i}/${j} w/s"
        awk '{ sum += $5; n++ } END { if (n > 0) print sum / n;}' ${j}_1024_iostat_${i}_extract.out
        echo "${i}/${j} rMB/s"
        awk '{ sum += $6; n++ } END { if (n > 0) print sum / n;}' ${j}_1024_iostat_${i}_extract.out
        echo "${i}/${j} wMB/s"
        awk '{ sum += $7; n++ } END { if (n > 0) print sum / n;}' ${j}_1024_iostat_${i}_extract.out
        echo "${i}/${j} I/O util"
        awk '{ sum += $14; n++ } END { if (n > 0) print sum / n;}' ${j}_1024_iostat_${i}_extract.out
        
        rm ${j}_1024_iostat_${i}_extract.out
        
        echo "${i}/${j} CPU util"
        awk '{ if ($12 > 0); sum += $12; n++ } END { if (n > 0) print (100 - sum / n);}' ${j}_1024_mpstat_${i}.out

        echo
        done
done

