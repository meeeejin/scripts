#!/bin/bash

result_dir="path/to/result-dir"
buf_size=( "5G" "10G" )

echo "Start TPCC for ORIGINAL VERSION"

# Compile the original source code
cd /path/to/mysql-x.x.x
cmake -DCMAKE_INSTALL_PREFIX=/path/to/mysql-x.x.x
make -j8 install

# Run TPC-C benchmark for original MySQL
for i in "${buf_size[@]}"
do
	# Initialize the device
	sudo dd if=/dev/zero of=/dev/xx bs=1M	
	sudo dd if=/dev/zero of=/dev/xx bs=1M	

	# Remove all data
	rm -rf /path/to/log/*
	rm -rf /path/to/data/*

	# Copy data
	cp -r /path/to/backup/data/* /path/to/data/
	cp -r /path/to/backup/log/* /path/to/log/

	# Run MySQL server
	echo "RUN MYSQL SERVER"
	cd /path/to/mysql-x.x.x
	./bin/mysqld_safe --defaults-file=/path/to/my.cnf \
	--innodb_buffer_pool_size=$i &>/dev/null &disown

	sleep 15s

	# Run TPC-C benchmark
	echo "START TPCC BENCHMARK"
	cd /path/to/tpcc-mysql

    # Collect the necessary info
	iostat -mx 1 > ${result_dir}/${i}_iostat.txt &
	./sleep-and-log.sh ${result_dir} ${i} &
    ./runBench.sh | tee ${result_dir}/${i}_tpcc.txt
	./mv-log.sh ${result_dir} ${i} &

	killall iostat

	ps cax | grep mysql > /dev/null
	if [ $? -eq 0 ]; then
		cd /path/to/mysql-x.x.x
		./bin/mysql -uroot \
			-e "show engine innodb status;" >> ${result_dir}/${i}_status.txt

		./bin/mysql -uroot \
		-e "SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool%';" >> ${result_dir}/${i}_bufstat.txt	

        ./bin/mysql -uroot \
        -e "SELECT EVENT_NAME, COUNT_STAR, SUM_TIMER_WAIT/1000000000 SUM_TIMER_WAIT_MS, \
        AVG_TIMER_WAIT/1000000000 AVG_TIMER_WAIT_MS \
        FROM performance_schema.events_waits_summary_global_by_event_name \
        WHERE SUM_TIMER_WAIT > 0 AND \
        EVENT_NAME LIKE 'wait/%' \
        ORDER BY SUM_TIMER_WAIT_MS DESC;" >> ${result_dir}/${i}_total_mutex.txt

        ./bin/mysql -uroot \
        -e "SHOW ENGINE INNODB MUTEX;" >> ${result_dir}/${i}_mutex.txt

		# Shutdown the server
		./bin/mysqladmin -uroot shutdown  
		sleep 600s
	fi
done
