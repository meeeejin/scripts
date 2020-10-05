#!/bin/bash

# Extract the I/O info for the NVMe device
grep "nvme0n1" /home/vldb/result/iostat.txt > nvme-io.txt

# Print the average r/s, average w/s, and total IOPS 
awk '{ rsum += $4; wsum += $5; n++ } END \
        { if (n > 0) \
                { print "r/s = "rsum / n", " \
                        "w/s = "wsum / n", " \
                        "total = "rsum / n + wsum / n; \
                } }' nvme-io.txt

rm nvme-io.txt