#!/bin/bash
RESULT_PATH='/home/mijin/starlab'

declare -a repo=(
            "mysql-with-aio-prefetch" 
            "OpenSSD_sector-level-mapping" 
            "SQLite-PPL"
            "ForestDB-Analyzer"
            "FaCE-temp"
            "mysql-with-face"
            "mysql-with-nvdimm"
            "rocksdb"
            "shareSQL"
            "Cosmos-plus-OpenSSD"
            "sqlite-more-lite"
            "mongo-mssd"
            "flashsql.github.io"
            "mongo-trim"
            "mysql-pmem"
            "SSDMapViewer"
            "sqlite3-base"
            "References"
            "StarLab-Project-Report"
            "innodb-doc-kr"
            "mysql-57-nvdimm-caching"
        )

for entry in "${repo[@]}"
do
    cd $RESULT_PATH
    
    echo "Clone $entry"
    git clone https://github.com/FlashSQL/$entry
    
    cd $entry

    echo "Github commit logs in 2020" > ${entry}.txt
    echo -n "Jan: " >> ${entry}.txt
    git rev-list --count --since="Jan 1 2020" --before="Feb 1 2020" --all >> ${entry}.txt
    echo -n "Feb: " >> ${entry}.txt
    git rev-list --count --since="Feb 1 2020" --before="Mar 1 2020" --all >> ${entry}.txt
    echo -n "Mar: " >> ${entry}.txt
    git rev-list --count --since="Mar 1 2020" --before="Apr 1 2020" --all >> ${entry}.txt
    echo -n "Apr: " >> ${entry}.txt
    git rev-list --count --since="Apr 1 2020" --before="May 1 2020" --all >> ${entry}.txt
    echo -n "May: " >> ${entry}.txt
    git rev-list --count --since="May 1 2020" --before="Jun 1 2020" --all >> ${entry}.txt
    echo -n "Jun: " >> ${entry}.txt
    git rev-list --count --since="Jun 1 2020" --before="Jul 1 2020" --all >> ${entry}.txt
    echo -n "Jul: " >> ${entry}.txt
    git rev-list --count --since="Jul 1 2020" --before="Aug 1 2020" --all >> ${entry}.txt
    echo -n "Jan-Jul: " >> ${entry}.txt
    git rev-list --count --since="Jan 1 2020" --before="Aug 1 2020" --all >> ${entry}.txt
    echo -n "Aug: " >> ${entry}.txt
    git rev-list --count --since="Aug 1 2020" --before="Sep 1 2020" --all >> ${entry}.txt
    echo -n "Sep: " >> ${entry}.txt
    git rev-list --count --since="Sep 1 2020" --before="Oct 1 2020" --all >> ${entry}.txt
    echo -n "Oct: " >> ${entry}.txt
    git rev-list --count --since="Oct 1 2020" --before="Nov 1 2020" --all >> ${entry}.txt
    echo -n "Nov: " >> ${entry}.txt
    git rev-list --count --since="Nov 1 2020" --before="Dec 1 2020" --all >> ${entry}.txt
    echo -n "Dec: " >> ${entry}.txt
    git rev-list --count --since="Dec 1 2020" --before="Jan 1 2020" --all >> ${entry}.txt
    echo -n "Total: " >> ${entry}.txt
    git rev-list --count --since="Jan 1 2020" --before="Jan 1 2021" --all >> ${entry}.txt

    mv ${entry}.txt $RESULT_PATH/
    cd $RESULT_PATH
    rm -rf $entry
done

grep "Jan-Jul" * | awk '{ print $2 }'
