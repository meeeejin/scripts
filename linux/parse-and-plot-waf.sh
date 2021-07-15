#!/bin/bash
# Parse-and-plot WAF for Cosmos+ OpenSSD
# $1 = The SDK terminal output
# $2 = .eps file name 
input=$1

# Parse the SDK terminal output
awk '{ print $8, $4 }' $1 | sed 's/MB//g' > parse.txt
awk 'NR == 1 { ssd = $1; nand = $2; print ssd / nand; } NR >= 2 { ssd = ssd + $1; nand = nand + $2; print $1 / $2, ssd / nand; }' parse.txt > waf.txt
rm parse.txt

# Plot a WAF graph 
gnuplot -persist <<-EOFMarker
    set terminal pos eps enhanced size 5,2.5 font "Helvetica,18"
    set output "$2.eps"
    set xlabel "Write Time (Per Minute)"
    set ylabel "WAF" offset 1.5
    #set ytic 0,0.1,1
    #set yrange [0:1] 
    #set xtic 0,10000,50000 
    #set xrange [0:50000]
    plot "waf.txt" using 1 with lines ls 3 title "Running WAF", \
        "waf.txt" using 2 with lines ls 1 title "Cumulative WAF";
EOFMarker
