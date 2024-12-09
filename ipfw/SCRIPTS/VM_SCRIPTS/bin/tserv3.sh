#!/bin/sh
#
# location: firewall VMs
#
# tserv3.sh - start up 3 listeners over TCP

zapall() {
kill -TERM $PID1 $PID2 $PID3
}

trap zapall SIGINT


export MYIP=`ifconfig em0 | grep inet | awk '{print $2}'`
export PORT1=5656
export PORT2=5657
export PORT3=5658

echo "Starting TCP listeners on [$PORT1],[$PORT2],[$PORT3]"

ncat -l -4 -k  $MYIP $PORT1 &
PID1=$!

ncat -l -4 -k  $MYIP $PORT2 &
PID2=$!

ncat -l -4 -k  $MYIP $PORT3 &
PID3=$!

wait

exit

# 

