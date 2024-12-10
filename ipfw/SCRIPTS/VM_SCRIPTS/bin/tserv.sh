#!/bin/sh
#
# location: firewall VMs
#
# tserv.sh - start up 1 listener over TCP

zapall() {
kill -TERM $PID1 
}

trap zapall SIGINT


export MYIP=`ifconfig em0 | grep inet | grep -v inet6 | awk '{print $2}'`

export PORT1=5656

echo "Starting TCP listener on [$PORT1]"

ncat -l -4 -k $MYIP $PORT1 &
PID1=$!

wait

exit

#

