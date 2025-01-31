#!/bin/sh
#
# location: firewall VMs
#
# userv5.sh - start up 5 listeners over udp

zapall() {
kill -TERM $PID1 $PID2 $PID3 $PID4 $PID5
}

trap zapall SIGINT


export MYIP=`ifconfig em0 | grep inet | grep -v inet6 | awk '{print $2}'`
export PORT1=5656
export PORT2=5657
export PORT3=5658
export PORT4=5659
export PORT5=5660


echo "Starting UDP listeners on [$PORT1],[$PORT2],[$PORT3],[$PORT4],[$PORT5]"

nc -l -k -u  $MYIP  $PORT1 &
PID1=$!

nc -l -k -u  $MYIP  $PORT2 &
PID2=$!

nc -l -k -u  $MYIP  $PORT3 &cd
PID3=$!

nc -l -k -u  $MYIP  $PORT4 &
PID4=$!

nc -l -k -u  $MYIP  $PORT5 &
PID5=$!

wait

exit

# 

