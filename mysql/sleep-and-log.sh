#!/bin/bash

sleep 185s
cp /path/to/mysql_error.log $1/$2_before_log.txt

cd /path/to/mysql-x.x.x
./bin/mysql -uroot \
        -e "show engine innodb status;" >> $1/$2_before_status.txt


