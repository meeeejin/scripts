#!/bin/bash
input=$1

gnuplot -persist <<-EOFMarker
    set term png size 450,300
    set output "$2.png" 
    set xlabel "Time Distance (s)"
    set ylabel "Cumulative Pages" offset 1.5
    datafile = "${input}"
    stats datafile
    set ytic 0,0.1,1
    set yrange [0:1] 
    set xtic 0,10000,50000 
    set xrange [0:50000]
    plot datafile using 2:(1./STATS_records) smooth cumulative notitle;
EOFMarker