#!/bin/sh
#
# location: firewall VMs
#
# userv3.sh - start up 3 listeners over udp

zapall() {
kill -TERM $PID1 $PID2 $PID3
}

trap zapall SIGINT


export MYIP=`ifconfig em0 | grep inet | grep -v inet6 | awk '{print $2}'`

export PORT1=5656
export PORT2=5657
export PORT3=5658


echo "Starting UDP listeners on [$PORT1],[$PORT2],[$PORT3]"

nc -l -k -u  $MYIP  $PORT1 &
PID1=$!

nc -l -k -u  $MYIP  $PORT2 &
PID2=$!

nc -l -k -u  $MYIP  $PORT3 &
PID3=$!

wait

exit

# 
#

