#!/bin/sh
#
# location: external Vms
#
# sh tcon.sh PORTNUM   - start up 1 connection over TCP
#

usage() {
  echo "sh tcon.sh PORTNUM"
  exit 1
}


#echo $#

if [ $# -ne 1 ]
then
  usage
else
  export PORT1=$1
fi

# echo "PORT1 = [$PORT1]"

export CONN="203.0.113.50"
export COUNT=1

export MYIP=`ifconfig em0 | grep inet | awk '{print $2}'`
export MYNAME="external1"


export MYIP=`ifconfig em0 | grep inet | awk '{print $2}'`

echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"
echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"| ncat $CONN $PORT1

export PREVIOUS_PORT=$PORT1

while :
do

  COUNT=`expr $COUNT + 1`

  read -p "ncat [$COUNT] ready. Enter a valid PORTNUM:  " PORT1

  if [ "X$PORT1" = "X" ]
    then
      PORT1=$PREVIOUS_PORT
  fi

  echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"
  echo "TCP connection from [$MYIP],[$PORT1],[$COUNT]"| ncat  $CONN $PORT1

  if [ $? -ne 0 ]
  then
    echo  "TCP connection [$MYIP],[$PORT1],[$COUNT] FAILED"
  fi

  PREVIOUS_PORT=$PORT1

done

