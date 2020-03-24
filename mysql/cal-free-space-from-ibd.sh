#!/bin/bash

target=$1

# Calculate the amount of data and free space of each page in the given .ibd file
echo "Parse $1"
innodb_space -f $1 space-index-pages-summary > space-summary.txt

echo
echo "The result is saved to space-summary.txt"
echo
echo "Parse space-summary.txt"

# Calculate the average free space of total pages in the given .ibd file and print the result
awk 'NR == 1 { min = 4096; max = 0; }
    { if ( $5~/^[0-9]+$/ ) {
    { if ( min > $5 ) { min = $5; } }
    { if ( max < $5 ) { max = $5; } }
    { n++; sum += $5; }}}
    END { print "\n# Parsing Result\nTotal number of pages =", n, 
        "\nTotal free space =", sum,
        "\nAverage free space per page =", sum / n, 
        "\nMin free space =", min, 
        "\nMax free space =", max; }' space-summary.txt > space-avg-free.txt

cat space-avg-free.txt
echo
echo "The result is saved to space-avg-free.txt"
