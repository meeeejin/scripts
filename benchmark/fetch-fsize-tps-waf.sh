#!/bin/bash
ORIGIN_DATA_DIR="/home/mijin/origin-data"
NS_DATA_DIR="/home/mijin/ns-data"
RESULT_DIR="/home/mijin/result"
ORIGIN_DEV="/dev/sda1"
NS_DEV="/dev/sdb1"

while [ 1 ]
do
	# Wrtie the current size of the database files
	ls -l ${ORIGIN_DATA_DIR} >> ${RESULT_DIR}/origin-size.txt &
	du -h ${ORIGIN_DATA_DIR} >> ${RESULT_DIR}/origin-total-size.txt &
	ls -l ${NS_DATA_DIR} >> ${RESULT_DIR}/ns-size.txt &
	du -h ${NS_DATA_DIR} >> ${RESULT_DIR}/ns-total-size.txt &

	# Write the current tps
	tail -n 1 ${RESULT_DIR}/tpcc-origin.txt >> ${RESULT_DIR}/tpcc-origin-per-30min.txt &
	tail -n 1 ${RESULT_DIR}/tpcc-ns.txt >> ${RESULT_DIR}/tpcc-ns-per-30min.txt &
	
	# Write the smartctl info 
	echo "sudo-passwd" | sudo -S smartctl -A ${ORIGIN_DEV} >> ${RESULT_DIR}/origin-smartlog.txt &
	echo "sudo-passwd" | sudo -S smartctl -A ${NS_DEV} >> ${RESULT_DIR}/ns-smartlog.txt &
	
	# Sleep 30 min 
	sleep 1800s
done
