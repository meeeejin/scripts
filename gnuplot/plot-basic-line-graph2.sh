#!/bin/bash
input=$1

gnuplot -persist <<-EOFMarker
    # setting
    set term png size 750,500
    set output "$2.png"

    set xlabel "Time (per 10s)" offset 1.5
    set ylabel "Transactions per 10 seconds"

    set pointsize 1

    set xrange [0:1080]
    set xtic 0,60,1080
    set yrange [3000:21000]
    set ytic 0,3000,21000
    set xtics mirror

    # plot
    plot "$1" index 0 with lines title "DRAM 11G", \
        "$1" index 1 with lines title "DRAM 14G", \
        "$1" index 2 with lines title "DRAM 17G";
EOFMarker