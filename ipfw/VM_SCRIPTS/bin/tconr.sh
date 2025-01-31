#!/bin/sh
#
# location: external Vms
#
# sh tconr.sh PORTNUM  SLEEPVAL  (randomized port numbers)  - start up 1 connection over TCP
#


usage() {
  echo "sh tconr.sh PORT1NUM  SLEEPVAL  (randomized port numbers)"
  exit 1
}


# echo $#

if [ $# -ne 2 ]
  then
    usage
fi


PORT1=$1
SLEEPVAL=$2


echo "PORT1     = [$PORT1]"
echo "SLEEPVAL = [$SLEEPVAL]"



export CONN="203.0.113.50"
export COUNT=1
export MYIP=`ifconfig em0 | grep inet | grep -v inet6 | awk '{print $2}'`
export MYNAME="external1"


echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"
echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"| ncat  $CONN $PORT1

while :
do

COUNT=`expr $COUNT + 1`

# use jot(1) to get a random port between 5656 and 5659.
# Connection to 5659 has no listener on firewall and will thus fail.

  PORT1=`jot -r 1 5656 5659 $RANDOM`

  echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"
  echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"| ncat  $CONN $PORT1

  if [ $? -ne 0 ]
  then
    echo  "TCP connection [$MYIP],[$PORT1],[$COUNT] FAILED"
  fi

  sleep $SLEEPVAL

done


#

