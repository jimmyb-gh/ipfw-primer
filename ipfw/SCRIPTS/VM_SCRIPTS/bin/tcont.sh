#!/bin/sh
#
# location: external Vms
#
# sh tcont.sh PORT1NUM SLEEPVAL  - keep hammering same TCP port every SLEEPVAL
#

usage() {
  echo "sh tcont.sh PORT1NUM  SLEEPVAL"
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

export CONN="203.0.113.50"
export COUNT=1
export MYIP=`ifconfig em0 | grep inet | awk '{print $2}'`


echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"
echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"| ncat  $CONN $PORT1

while :
do

  COUNT=`expr $COUNT + 1`

  echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"
  echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"| ncat  $CONN $PORT1

  if [ $? -ne 0 ]
  then
    echo  "TCP connection [$MYIP],[$PORT1],[$COUNT] FAILED"
  fi

  sleep $SLEEPVAL

done
# 

