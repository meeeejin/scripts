#!/bin/bash

function msecs() {
    echo $((`date +%s%N` / 1000000))
}

function msec_to_sec() {
    MSECS=$1
    SECS=$(($MSECS / 1000))
    MSECS=$(($MSECS - $SECS * 1000))
    printf %d.%03d $SECS $MSECS
}

TOTAL_MSECONDS=0
for q in {1..22}
do
    echo "start query-$q"
    START=`msecs`
    echo exit | sqlplus tpch/passwd @/home/mijin/tpch-2.18.0/dbgen/queries/query-$q.sql > /dev/null
    END=`msecs`
    DURATION=$(( $END - $START ))
    echo "duration of query-$q = $DURATION"
    printf "%d: \t%16s secs\n" $q `msec_to_sec $DURATION` >> /home/mijin/oracle-fio/tpch.log
    TOTAL_MSECONDS=$(( $TOTAL_MSECONDS + $DURATION ))
done

printf "Total: \t%16s secs\n" `msec_to_sec $TOTAL_MSECONDS` >> /home/mijin/oracle-fio/tpch-final.log
