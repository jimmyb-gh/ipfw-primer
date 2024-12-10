#!/bin/sh
#
# location: firewall VMs
#
# userv.sh PORTNUM   - start up 1 listener over UDP
#

usage() {
  echo "sh userv.sh PORTNUM"
  exit 1
}

#echo $#

if [ $# -ne 1 ]
then
  usage
else
  PORT1=$1
fi

echo "PORT1 = [$PORT1]"

zapall() {
kill -TERM $PID1 
}

trap zapall SIGINT

export MYIP=`ifconfig em0 | grep inet | grep -v inet6 | awk '{print $2}'`


echo "Starting UDP listener on [$MYIP],[$PORT1]"

# echo nc -l -k -u  $MYIP  $PORT1
nc -l -k -u  $MYIP  $PORT1 &
PID1=$!

wait

exit

# 

