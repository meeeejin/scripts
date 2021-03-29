#!/bin/sh

file=$1
plotfile=${file}_gnuplot

cat ${file} | awk '{printf "%s,%d,%d,%.3f,%d\n",$7, $8, $10, $4, NR}' > ${plotfile};

gnuplot -persist <<-EOFMarker
    set te png giant size 800,600;
    set xlabel "Time (second)";
    set ylabel "Logical Sector Number";
    set pointsize 0.2;
    set datafile separator ",";

    set xtic 0,600,3600
    set xrange [0:3600]
    #set ytic 0,,2e+10
    set yrange [1e+10:2e+10]

    set output "${file}.png";
    plot "< grep R ${plotfile}" u 4:2 ti "Read", "< grep W ${plotfile}" u 4:2 ti "Write";
    
    set output "${file}_read.png";
    plot "< grep R ${plotfile}" u 4:2 ls 1 ti "Read";
    
    set output "${file}_write.png";
    plot "< grep W ${plotfile}" u 4:2 ls 2 ti "Write";
EOFMarker

rm -f ${plotfile}
