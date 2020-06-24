#!/bin/bash

SET=$(seq 34 51)

for i in $SET
do
    grep "InnoDB: $i " $1 > $i.txt
    awk '{ print $6, $13 }' $i.txt | sort -k 1 -n > $i-parse.txt
    #nl -s" " $i.txt | awk '{ print $1, $7 }' > $i-r.txt
    /home/mijin/tpcc-mysql/970pro/new/test $i-parse.txt $i-dw.txt
    sort -k 2 -n -r $i-dw.txt | awk '{ print $2 }' > $i-dc.txt
    /home/mijin/tpcc-mysql/970pro/new/comparision/nc/test $i-dc.txt $i-final.txt
    #awk '{ print $3, $2 }' $i-rs.txt > $i-r.txt
    ./plot.sh $i-dc.txt $i
    #./plot-w.sh $i-dc.txt $i-w-detail
    #./plot-dw.sh $i-final.txt $i-dw
done
