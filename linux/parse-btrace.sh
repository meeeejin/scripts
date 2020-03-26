#!/bin/bash

# input: raw blktrace file
input=$1

rtotal=0
rcount=0
rmin=0
rmax=0
ravg=0

wtotal=0
wcount=0
wmin=0
wmax=0
wavg=0

# parse the raw data
echo "Parse the raw data"
grep "D\s\+W\|D\s\+R" $input > issue.RW
grep "C\s\+W" $input > complete.W
grep "C\s\+R" $input > complete.R

# extract the issue info from myslqd
echo "Extract MySQL info"
grep -e "mysqld" issue.RW > issue-mysql.RW
rm issue.RW

issue="issue-mysql.RW"
complete_r="complete.R"
complete_w="complete.W"

# read the file line by line
echo "Caculate min, max, avg latency..."
while IFS= read -r line
do
	# extract the I/O type
	io=$(echo "$line" | awk '{ print $7 }')
	
	# extract the issued time
	block_number=$(echo "$line" | awk '{ print $8 }')
	issue_time=$(echo "$line" | awk '{ print $4 }')

	if [ $io == "R" ]
	then
		# search the same block info in the second input file, then extract the completed time
		cline=$(grep "C  WS $block_number" $complete_r)
		complete_time=$(echo "$cline" | awk '{ print $4 }')

		# calculate the elapsed time
		elapsed=$(echo $complete_time $issue_time | awk '{ print $1 - $2 }')
		
		# calculate min/max and store the info
		if [ $rcount == 0 ]
			then
				rmin=$elapsed
				rmax=$elapsed
			else
				rmin=$(echo $rmin $elapsed | awk '{ if ( $1 > $2 ) print $2; else print $1 }')
				rmax=$(echo $rmax $elapsed | awk '{ if ( $1 < $2 ) print $2; else print $1 }')
		fi
		
		rtotal=$(echo $rtotal $elapsed | awk '{ print $1 + $2 }')
		rcount=$(( rcount + 1))
	elif [ $io == "WS" ]
	then
		# search the same block info in the second input file, then extract the completed time
		cline=$(grep "C  WS $block_number" $complete_w)
		complete_time=$(echo "$cline" | awk '{ print $4 }')

		# calculate the elapsed time
		elapsed=$(echo $complete_time $issue_time | awk '{ print $1 - $2 }')	

		# calculate min/max and store the info
		if [ $wcount == 0 ]
			then
				wmin=$elapsed
				wmax=$elapsed
			else
				wmin=$(echo $wmin $elapsed | awk '{ if ( $1 > $2 ) print $2; else print $1 }')
				wmax=$(echo $wmax $elapsed | awk '{ if ( $1 < $2 ) print $2; else print $1 }')
		fi
		wtotal=$(echo $wtotal $elapsed | awk '{ print $1 + $2 }')
		wcount=$(( wcount + 1))
	fi
done < "$issue"

ravg=$(echo $rtotal $rcount | awk '{ print $1 / $2 }')
wavg=$(echo $wtotal $wcount | awk '{ print $1 / $2 }')

echo
echo "===================================== Result ====================================="
echo

echo "Read:	min = $rmin	max = $rmax	average = $ravg"
echo "Write:	min = $wmin	max = $wmax	average = $wavg"
