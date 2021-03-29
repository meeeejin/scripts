#!/bin/bash
input=$1

gnuplot -persist <<-EOFMarker
    set term png size 450,300
    set output "$2.png"

    set xlabel "Working Set Period"
    set ylabel "Fraction of Data File" offset 1.5

    set ytic 0,0.1,1
    set yrange [0:1] 
    set xtic 0,10000,50000 
    set xrange [0:50000]

    plot "$1" using 1 with lines title "Reads", \
        "$1" using 2 with lines title "Writes", \
        "$1" using 3 with lines title "Total";
EOFMarker