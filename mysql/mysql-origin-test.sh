#!/bin/bash

result_dir="path/to/result-dir"
device="xxx"
buf_size=( "10G" "20G" "30G" "40G" "50G" )
scan_depth=( 1024 2048 )

echo "Start TPC-C benchmark for ORIGINAL VERSION"

# Compile the original source code
cd /path/to/mysql-x.x.x
cmake -DCMAKE_INSTALL_PREFIX=/path/to/mysql-x.x.x
make -j8 install

# Run TPC-C benchmark for original MySQL
for i in "${buf_size[@]}"
do
    for j in "${scan_depth[@]}"
    do
        # Check whether the MySQL server is running now, or not
        ps cax | grep mysql > /dev/null
        if [ $? -eq 0 ]; then
            cd /path/to/mysql-x.x.x
            ./bin/mysqladmin -uroot shutdown  
        fi
        
        # Remove all data
        rm -rf /path/to/log-dir/*
        rm -rf /path/to/data-dir/*

        # Copy data
        cp -r /path/to/backup/data/* /path/to/data-dir/
        cp -r /path/to/backup/log/* /path/to/log-dir/

        # Run MySQL server
        echo "RUN MYSQL SERVER"
        cd /path/to/mysql-x.x.x
        ./bin/mysqld_safe --defaults-file=/path/to/my.cnf \
        --innodb_buffer_pool_size=$i --innodb_lru_scan_depth=$j &>/dev/null &disown

        sleep 15s

        echo "START TPCC BENCHMARK"
        cd /path/to/tpcc-mysql
        
        # Report
        iostat -mx 1 > ${result_dir}/${device}/${i}_${j}_iostat_origin.out &
        mpstat -P ALL 1 > ${result_dir}/${device}/${i}_${j}_mpstat_origin.out &
        ./runBench.sh | tee ${result_dir}/${device}/${i}_${j}_tpcc_origin.out
        
        killall -9 iostat mpstat
    done
done

# Shutdown the MySQL server
ps cax | grep mysql > /dev/null
if [ $? -eq 0 ]; then
    cd /path/to/mysql-x.x.x
    ./bin/mysqladmin -uroot shutdown  
fi

