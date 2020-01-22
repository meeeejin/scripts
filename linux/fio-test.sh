#!/bin/bash

DEVICE_PATH='/dev/xxx'
RESULT_PATH='/path/to/result-dir'

jobtype=( randread randwrite )
bs=( 4k 8k 16k )
iodepth=( 1 4 8 16 32 64 )
fsync=( 0 1 )

# random read/write
for i in "${jobtype[@]}"
do
    for j in "${bs[@]}"
    do
        for k in "${iodepth[@]}"
        do
            for l in "${fsync[@]}"
            do
                fname="${i}_${j}_${k}_${l}"
                fio --filename=$DEVICE_PATH --name=$fname \
                --direct=1 --rw=$i --bs=$j --numjobs=4 --fsync=$l \
                --runtime=1800 --group_reporting --iodepth=$k \
                --ioengine=libaio --output=$RESULT_PATH/$fname.out
            done
        done
    done
done
