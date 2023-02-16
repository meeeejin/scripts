
iostat -mx 1 > io.txt &
mpstat -P ALL 1 > ms.txt &

./bin/linkbench -c config/MyConfig.properties -csvstats final-stats.csv -csvstream streaming-stats.csv -r

killall iostat mpstat
