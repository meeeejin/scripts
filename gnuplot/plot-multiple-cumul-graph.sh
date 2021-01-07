#!/bin/bash
input=$1

gnuplot -persist <<-EOFMarker
    set terminal pos eps enhanced size 4.5,2.5 font "Helvetica,20"
    set output "$2.eps"
    set boxwidth 0.9
    
    #set term png size 450,300
    #set output "$2.png" 
    
    set xlabel "Fraction of Total Database" offset 1.5
    set ylabel "Fraction of Working Sets" offset 1.5

    datafile = "${input}"
    stats datafile

    set ytic 0,0.1,1
    set yrange [0:1] 
    #set xtic 0,5,23 
    #set xrange [0:23]

    plot datafile using 4:(1./STATS_records) smooth cumulative title "Reads", \
        datafile using 5:(1./STATS_records) smooth cumulative title "Writes", \
        datafile using 6:(1./STATS_records) smooth cumulative title "Total";
EOFMarker