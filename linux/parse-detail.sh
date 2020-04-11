#!/bin/bash

input=$1
count=0
prev_page_no=""

# parse the important info from the given file
echo -e "Page number \tCount\tTime\tLSN Gap\t\tFix Count"

# read the file line by line
while IFS= read -r line
do
    # fetch the info of the current line
    raw_time=$(echo "$line" | cut -d" " -f1 | cut -d"T" -f2 | cut -d"Z" -f1)
    cur_page_no=$(echo "$line" | cut -d" " -f2)
    cur_lsn=$(echo "$line" | cut -d" " -f3)
    cur_fix_count=$(echo "$line" | cut -d" " -f4)

    # parse the time info 
    cur_hour=$(echo "$raw_time" | cut -d":" -f1)
    cur_minute=$(echo "$raw_time" | cut -d":" -f2)
    #cur_second=$(echo "$raw_time" | cut -d":" -f3 | cut -d"." -f1)
    #cur_millisecond=$(echo "$raw_time" | cut -d":" -f3 | cut -d"." -f2)

    if [ "$cur_page_no" == "$prev_page_no" ]
    then
        # cumulate the info
        count=$(( count + 1))
        total_lsn=$((total_lsn + cur_lsn))
        total_fix_count=$((total_fix_count + cur_fix_count))

        # calculate the time interval
        cur_time=$((10#$cur_hour * 60 + 10#$cur_minute))
        prev_time=$((10#$prev_hour * 60 + 10#$prev_minute))

        if [ $((10#$cur_time)) -gt $((10#$prev_time)) ]
        then
            time_gap=$((10#$cur_time - 10#$prev_time))
        else
            time_gap=$((10#$prev_time - 10#$cur_time))
        fi

        total_time_gap=$((total_time_gap + time_gap))
        prev_hour=$cur_hour
        prev_minute=$cur_minute
    else
        # print the final result
        if [ $count != 0 ]
        then
            final_lsn=$((total_lsn / count))
            final_fix_count=$((total_fix_count / count))
            if [ $count -gt 1 ]
            then
                final_time_gap=$((total_time_gap / $((count - 1))))
            else
                final_time_gap=0
            fi
            echo -e "$prev_page_no \t$count\t$final_time_gap\t$final_lsn\t$final_fix_count"

            # reset the count value
            count=0
        fi

        # save the new info 
        count=$(( count + 1))
        prev_page_no=$cur_page_no
        prev_hour=$cur_hour
        prev_minute=$cur_minute
        #prev_second=$cur_second
        #prev_millisecond=$cur_millisecond
        total_lsn=$cur_lsn
        total_fix_count=$cur_fix_count
        total_time_gap=0
    fi
done < "$input"