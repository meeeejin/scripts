#!/bin/bash

cp /path/to/mysql_error.log $1/$2_after_log.txt

cd /path/to/mysql-x.x.x
./bin/mysql -uroot \
        -e "show engine innodb status;" >> $1/$2_after_status.txt


