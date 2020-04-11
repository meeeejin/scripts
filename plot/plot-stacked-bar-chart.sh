#!/bin/bash
input=$1

gnuplot -persist <<-EOFMarker
	# setting
	set term png size 1000,500 font "Helvetica,10"
	set output "plot.png"

	set title "Experimental Results of Multiple MySQL Containers with LinkBench on Docker" font "Helvetica,15"

	set yrange [0:35000]

	set style data histogram
	set style histogram rowstacked
	set style fill solid border -1

	set key Left outside

	set ylabel "OPS" offset 1.5
	set boxwidth 0.75 relative

# plot
	plot "${input}" using 2:xtic(1) notitle, \
			 '' using 3 title "Instance 1", \
			 '' using 4 title "Instance 2", \
			 '' using 5 title "Instance 3", \
			 '' using 6 title "Instance 4", \
			 '' using 7 notitle;
EOFMarker
