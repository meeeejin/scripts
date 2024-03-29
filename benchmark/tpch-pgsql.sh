end=$((SECONDS+86400))

# Run TPC-H benchmark for 86400 seconds
while [ $SECONDS -lt $end ]
do
    ./tpch.sh ./results postgres vldb
    mv results /home/vldb/backup/tpch-results/results-$SECONDS

    pg_ctl -D /home/vldb/test-data -m smart stop
    sync
    echo "passwd" | sudo -S sysctl -w vm.drop_caches=3
    pg_ctl -D /home/vldb/test-data -l /home/vldb/test-log/logfile start
done