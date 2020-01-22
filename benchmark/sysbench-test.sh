sysbench --test=/path/to/sysbench-0.5/sysbench/tests/db/oltp.lua \
        --mysql-host=localhost  --mysql-db=sbtest_8k --mysql-user=root \
        --max-requests=0 --oltp-table-size=2000000 \
        --max-time=1800  --oltp-tables-count=400 --report-interval=10 \
        --db-ps-mode=disable  --random-points=10   --mysql-table-engine=InnoDB \
        --mysql-port=3307   --num-threads=200 run
