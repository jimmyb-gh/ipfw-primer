#!/bin/sh
# GENERIC VERSION
# runvmgeneric.sh
# location: FreeBSD Host
#
#
#  runvmgeneric.sh - run virtual machines specified on the command line.
#
#  To use this script, run mkbr.sh first to set up the bridge and
#  tap configurations for the desired network architecture.
#
#
#  Essentially, this script is a big case statement.  It gets the
#  command line names of the virtual machines and calls a function
#  that starts the virtual machine.
#



# pick up environment for this run
. ./vm_envs.sh


#set -x

export WKDIR=$HOME/ipfw-primer/ipfw/HOST_SCRIPTS

echo "[${WKDIR}]"


usage() {
    echo "Usage: /bin/sh runvm.sh  vmname [vmname ...]"
    echo "Each virtual machine opens a serial interface used for terminal access."
    echo "Run this command from the HOST_SCRIPTS directory."
    echo ""
    exit 1
}


CURDIR=`pwd`

if [ "X${CURDIR}" != "X${WKDIR}" ]
then
    usage;
fi


if [ $# = 0 ]
then
   usage;
fi

# Functions for each VM

dnshost_vm () {
  # DNS host
  echo "in function: [${_DNSHOST_telnetport}]"
  sudo /bin/sh dnshost.sh 
  return
}


external1_vm () {
  # external1
  echo "in function: [${_EXTERNAL1_telnetport}]"
  sudo /bin/sh external1.sh
  return
}


external2_vm () {
  # external2
  echo "in function: [${_EXTERNAL2_telnetport}]"
  sudo /bin/sh external2.sh
  return
}

external3_vm () {
  # external3
  echo "in function: [${_EXTERNAL3_telnetport}]"
  sudo /bin/sh external3.sh
  return
}

firewall_vm () {
  # Firewall
  echo "in function: [${_FIREWALL_telnetport}]"
  sudo /bin/sh firewall.sh
  return
}

firewall2_vm () {
  # Firewall2
  echo "in function: [${_FIREWALL2_telnetport}]"
  sudo /bin/sh firewall2.sh
  return
}

internal_vm () {
  # internal
  echo "in function: [${_INTERNAL_telnetport}]"
  sudo /bin/sh internal.sh
  return
}

jail1_vm () {
  # jail1
  echo "in function: [${_JAIL1_telnetport}]"
  sudo /bin/sh jail1.sh
  return
}

v6only_vm () {
  # v6only
  echo "in function: [${_V6ONLY_telnetport}]"
  sudo /bin/sh v6only.sh
  return
}


#
# Startup the requested VMs
#
# script startup point here

TMUXPID=`pgrep tmux`


if [ "X${TMUXPID}" = "X" ] # if nobody home
  then 
     tmux                  # start me up
#     echo "Nobody home"    # start me up
else
     echo "tmux is running as PID [${TMUXPID}]"
fi



PARAM=$1

while [ "X${PARAM}" != "X" ]
do
  echo "PARAM = [${PARAM}]"

  case ${PARAM} in

    dnshost)  
        echo "dnshost ..."
	echo "_DNSHOST_telnetport = [${_DNSHOST_telnetport}]"
        dnshost_vm
      ;;

    external1)  
        echo "external1 ..."
	echo "_EXTERNAL1_telnetport = [${_EXTERNAL1_telnetport}]"
        external1_vm
      ;;

    external2)  
        echo "external2 ..."
	echo "_EXTERNAL2_telnetport = [${_EXTERNAL2_telnetport}]"
        external2_vm
      ;;

    external3)  
        echo "external3 ..."
	echo "_EXTERNAL3_telnetport = [${_EXTERNAL3_telnetport}]"
        external3_vm
      ;;

    firewall)  
        echo "firewall ..."
	echo "_FIREWALL_telnetport = [${_FIREWALL_telnetport}]"
        firewall_vm
      ;;

    firewall2)  
        echo "firewall2 ..."
	echo "_FIREWALL2_telnetport = [${_FIREWALL2_telnetport}]"
        firewall2_vm
      ;;

    internal)  
        echo "internal ..."
	echo "_INTERNAL_telnetport = [${_INTERNAL_telnetport}]"
        internal_vm
      ;;

    jail1)  
        echo "jail1 ..."
	echo "_JAIL1_telnetport = [${_JAIL1_telnetport}]"
        jail1_vm
      ;;

    v6only)  
        echo "v6only ..."
	echo "_V6ONLY_telnetport = [${_V6ONLY_telnetport}]"
        v6only_vm
      ;;

    *)  
      echo ""
      echo "**** ERROR: NO VM NAMED [$PARAM]"
      echo ""
    ;;

  esac

  shift

  sleep 3

  PARAM=$1
done

exit 0


