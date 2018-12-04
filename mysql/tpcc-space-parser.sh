#!/bin/bash

test_dir=$1
target_database=$2
result_dir="/result/directory"

# Keywords for space file structure
keywords=( "space-indexes" "space-page-type-regions" 
        "space-page-type-summary" "space-extents-illustrate" \
        "space-lsn-age-illustrate")

# TPC-C tables
tablespaces=( "district.ibd" "new_orders.ibd" "orders.ibd" \
        "customer.ibd" "history.ibd" "order_line.ibd" \
        "stock.ibd" "item.ibd" "warehouse.ibd" )

# Change directory to test directory
cd ${test_dir}

# List all tablespaces avaliable from the system
echo "======== ibdata1 / system-spaces ========"
innodb_space -s ibdata1 system-spaces | tee ${result_dir}/original-ibdata1-system-spaces

# Gather some information about the system tablespace
for i in "${keywords[@]}"
do
    echo "======== ibdata1 / ${i} ========"
    innodb_space -s ibdata1 ${i} | tee ${result_dir}/original-ibdata1-${i}
done

# Change directory to target database
cd ${target_database}

# Gather some information about all tablespaces
for i in "${tablespaces[@]}"
do
    for j in "${keywords[@]}"
    do
        echo "======== ${i} / ${j} ========"
       innodb_space -f ${i} ${j} | tee ${result_dir}/original-${i}-${j}
    done
done
