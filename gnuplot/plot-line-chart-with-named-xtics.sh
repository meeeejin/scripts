#!/bin/bash
input=$1

gnuplot -persist <<-EOFMarker
	# setting
	set terminal pos eps enhanced size 4.5,3 font "Helvetica,20"
	set output "$2.eps"
	set boxwidth 0.9

    set ylabel "Transactions per minute Count (TpmC)" offset 1.5
   
    set style line 1 lt 1 pt 4
    set style line 2 lt 1 pt 7
    set pointsize 2
    set key at 4.8,33400
    set ytic 0,7000,35000
	set yrange [0:35000]
	
	set xrange [0:5]
    set xtics ("R:W=1:1"1,"R:W=2:1"2,"R:W=3:1"3,"R:W=4:1"4)

# plot
	plot "${input}" index 0 u 1:2 ls 1 with linespoints title "A", \
	     "${input}" index 1 u 1:2 ls 2 with linespoints title "B";
EOFMarker
