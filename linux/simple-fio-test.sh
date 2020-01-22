#!/bin/bash

DEVICE_PATH='/dev/xxx'
RESULT_PATH='/path/to/result-dir'

jobtype=( randread randwrite )
fsync=( 0 1 )

for i in "${jobtype[@]}"
do
    for j in "${fsync[@]}"
    do
        fname="$DEVICE_PATH_${i}_${j}"
        fio --name=$fname --filename=$DEVICE_PATH \
        --rw=$i --direct=1 --ioengine=libaio --bs=4k \
        --numjobs=4 --iodepth=32 --runtime=1200 --fsync=$j\
        --group_reporting --output=$RESULT_PATH/$fname.out
    done
done
