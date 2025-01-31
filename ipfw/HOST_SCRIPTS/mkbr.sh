#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD startup script for bridge and tap devices.
#
# mkbr.sh: FreeBSD startup script for bridge and tap devices.
# EXAMPLE Usage: sudo /bin/sh mkbr.sh reset bridge0 tap0 tap1 bridge1 tap2 bridge2 tap3 tap4 tap5 em0
#
# mkbr.sh - manage bridge and tap interfaces for FreeBSD.
#
# Have fun, but don't blame me if it smokes your machine.
# 
# This script is used to start the bridge and tap interfaces.
#
# To create one bridge, two tap interfaces, and connect the
# local ethernet interace (here em0), run under sudo as follows:
#   sudo /bin/sh mkbr.sh reset bridge0 tap0 tap1 em0
#
# The script can be used to create any number of  bridges and taps
# for any internal network design:
#   sudo /bin/sh mkbr.sh reset bridge0 tap0 tap1 bridge1 tap2 tap3 tap4 bridge2 tap5 em0 ... etc.
#
# To add other taps to existing bridges, do not specify the "reset" parameter.
#   sudo /bin/sh mkbr.sh       bridge0 tap10 tap11  bridge1 tap12 tap13  ... etc.
#
# To delete all bridge and tap devices:
#   sudo /bin/sh mkbr.sh reset
#
#

#set -x


usage() {
   echo "Usage: mkbr.sh  ["reset"] <bridgeN> <tapA> [[<bringeM>] <tapB> <tapC> ...]"
   echo "You must be root to run this script."
   exit 1
}


if [ "X0" != "X`id -u`" ]
then
	  usage
  fi

if [ $# = 0 ]
then
   usage;
fi

if [ $1 = "reset" ]
then
  echo
  echo "Note - if_bridge and/or if_tap may be compiled into the kernel and can't be  unloaded.  Adjust interfaces manually if necessary."
  echo
  echo "unloading..."
  kldunload if_bridge
  kldunload if_tap
  echo
  echo "Deleting any remaining bridge and tap devices:"

  for i in `ifconfig -l`
  do
    echo "Interface: ${i}"

    case ${i} in

        bridge*) 
            echo " ... destroying bridge ${i}"
            ifconfig ${i} destroy
            ;;
        tap*)
            echo " ... destroying tap ${i}"
            ifconfig ${i} destroy
            ;;
    esac
  done

  sleep 1
  echo "loading..."
  kldload if_bridge
  kldload if_tap
  shift
  RESET="Y"
  echo "RESET=Y"
  # Before using the tap devices in QEMU, two sysctls require adjustment:
  sysctl net.link.tap.user_open=1
  sysctl net.link.tap.up_on_open=1
else
  RESET="N"
  echo "RESET=N"
fi


PARAM=$1

while [ "X${PARAM}" != "X" ]
do
#  echo "PARAM=[$PARAM]"

  case $PARAM  in

    bridge*)  BRIDGE=$1

       #  if [ "$RESET" = "Y" ]
       #  then
           echo ifconfig $BRIDGE create
                ifconfig $BRIDGE create
           echo ifconfig $BRIDGE 
                ifconfig $BRIDGE 
       #  fi
         echo ifconfig $BRIDGE up
              ifconfig $BRIDGE up
         ;;

    tap*)  TAP=$1
       #  if [ "$RESET" = "Y" ]
       #  then
           echo ifconfig $TAP create
                ifconfig $TAP create
       #  fi
         echo "ifconfig $BRIDGE addm $TAP "
               ifconfig $BRIDGE addm $TAP 
         ;;

    *)   echo "*** Checking to see if $1 is a valid interface"
         TMPINT=$1
         RESULT="IS NOT"
         for i in `ifconfig -l`
         do
#           echo $i
           if [ "${i}X" = "${TMPINT}X" ]
           then
              echo "Found a valid interface: ${TMPINT} Adding it to the bridge. Check results."
              echo "ifconfig $BRIDGE addm $TMPINT"
                    ifconfig $BRIDGE addm $TMPINT
              RESULT="IS"
              break;  
           else
              echo -n "."
           fi
         done

         echo "Interface ${TMPINT} $RESULT a valid interface."
         ;;
  esac

  shift
  PARAM=$1
done


exit 0
