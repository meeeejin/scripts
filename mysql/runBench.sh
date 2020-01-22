export LD_LIBRARY_PATH=/path/to/mysql-x.x.x/lib
HOST=localhost

DEVICE_PATH='/dev/xxx'
SMARTCTL_PATH='/path/to/smartctl-result'
BLKTRACE_PATH='/path/to/blktrace-result'

echo "sudo-passwd" | sudo -S smartctl -A "$DEVICE_PATH" > "$SMARTCTL_PATH/before.txt"
echo "sudo-passwd" | sudo -S btrace "$DEVICE_PATH" > "$BLKTRACE_PATH/output.txt" &

./tpcc_start -h${HOST} -P3306 -dtpcc2000 -uroot -w2000 -c64 -r10 -l3600

echo "sudo-passwd" | sudo -S killall -15 btrace
echo "sudo-passwd" | sudo -S smartctl -A "$DEVICE_PATH" > "$SMARTCTL_PATH/after.txt"
