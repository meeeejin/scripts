export LD_LIBRARY_PATH=/path/to/mysql-x.x.x/lib

DEVICE_PATH='/dev/xxx'
BLKTRACE_PATH='/path/to/output-dir'

echo "sudo-passwd" | sudo -S btrace "$DEVICE_PATH" > "$BLKTRACE_PATH/result.out" &

./sysbench_test.sh

echo "sudo-passwd" | sudo -S killall -15 btrace
