#!/bin/sh
#
# location: external Vms
#
# sh ucont.sh PORT1NUM SLEEPVAL  - keep hammering same UDP port every SLEEPVAL
#

usage() {
  echo "sh ucont.sh PORT1NUM  SLEEPVAL"
  exit 1
}

#echo $#

if [ $# -ne 2 ]
  then
    usage
fi


export PORT1=$1
export SLEEPVAL=$2

echo "PORT1     = [$PORT1]"
echo "SLEEPVAL = [$SLEEPVAL]"

#export CONN="10.10.10.50"
export CONN="203.0.113.50"
export COUNT=1
export MYIP=`ifconfig em0 | grep inet | awk '{print $2}'`




echo "UDP packet from [$MYIP],[$PORT1],[$COUNT]"
echo "UDP packet from [$MYIP],[$PORT1],[$COUNT]"| ncat -u  $CONN $PORT1

while :
do

  COUNT=`expr $COUNT + 1`

#  echo "UDP packet from [$MYIP],[$PORT1],[$COUNT]"
#  echo "UDP packet from [$MYIP],[$PORT1],[$COUNT]"| ncat -u $CONN $PORT1

  echo "UDP packet from [$MYIP],[$PORT1],[$COUNT]"
  echo "UDP packet from [$MYIP],[$PORT1],[$COUNT]"| ncat -u $CONN $PORT1

  if [ $? -ne 0 ]
  then
    echo  "UDP packet [$MYIP],[$PORT1],[$COUNT] FAILED"
  fi

  sleep $SLEEPVAL

done
# 

