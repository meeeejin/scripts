#!/bin/bash
# For the duplicate test

input=$1

# Sort the input file using the 7th column
sort -k 7 ${input} > s-${input}

# Count the duplicate elements based on the 7th column 
awk '{ print $7 }' s-${input} | uniq -c > s-u-${input}

# Sort the file reversely using the 1st column
sort -k 1 -n -r s-u-${input} > s-u-r-${input}

# Count the duplicate elements based on the 7th column 
awk '{ print $1 }' s-u-r-${input} | uniq -c > s-u-r-u-${input}

# Print the result
cat s-u-r-u-${input}