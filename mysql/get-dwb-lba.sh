#!/bin/bash

FILE=$1
PSIZE=$2

echo
echo "DWB LBA of $1:"

if [ $PSIZE -eq 4 ]; then # 4KB
    echo "  $2 KB Pages, Total # of DWB pages = 256 * 2 = 512; assuming 512 byte sectors"
    printf "\nStart\t\tBlock1\t\tBlock2\t\tEnd\n"
    sudo hdparm --fibmap $FILE | \
    awk 'NR == 5 { printf "%d\t%d\t%d\t%d\n\n", \
        256 * 8 + $2, \
        256 * 8 + $2, 512 * 8 + $2, \
        768 * 8 + $2 - 1}'
elif [ $PSIZE -eq 16 ]; then # 16KB
    echo "  $2 KB Pages, Total # of DWB pages = 64 * 2 = 128; assuming 512 byte sectors"
    printf "\nStart\t\tBlock1\t\tBlock2\t\tEnd\n"
    sudo hdparm --fibmap $FILE | \
    awk 'NR == 5 { printf "%d\t%d\t%d\t%d\n\n", \
        64 * 32 + $2, \
        64 * 32 + $2, 128 * 32 + $2, \
        192 * 32 + $2 - 1}'
fi