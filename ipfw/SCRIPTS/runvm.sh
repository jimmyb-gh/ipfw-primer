#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for multiple VMs at once.
#
# runvm.sh: FreeBSD QEMU VM startup script for multiple VMs.
# EXAMPLE Usage: /bin/sh runvm.sh  firewall external1 external2 internal
#
# location: FreeBSD Host
#
#  runvm.sh - run virtual machines specified on the command line.
#
#  To use this script, run mkbr.sh first to set up the bridge and
#  tap configurations for the desired network architecture.
#
# NOTE: this script works best on XFCE4 desktop as it takes advantage of the
#       xfce4-terminal and it's ability to use multiple tabs.
#
#  >>>> It is unlikely to work on another desktop.  <<<<
#
#  Essentially, this script is a big case statement.  It gets the
#  command line names of the virtual machines and calls a function
#  that starts the virtual machine.
#


# pick up environment for this run
. ./vm_envs.sh


#set -x

#WKDIR=$HOME/LAB/SCRIPTS
export WKDIR=$HOME/ipfw

echo "[${WKDIR}]"


usage() {
    echo "Usage: /bin/sh runvm.sh  vmname [vmname ...]"
    echo "Each virtual machine opens up on xfce4-terminal with two tabs -"
    echo "   one for the qemu virtual machine, and one for the serial"
    echo "   terminal interface."
    echo ""
    exit 1
}


CURDIR=`pwd`

if [ "X${CURDIR}" != "X${WKDIR}/SCRIPTS" ]
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
  xfce4-terminal --window --geometry="80x24+50+50" --zoom="-1" \
               -T "${_DNSHOST_name}" -e "bash -c \"cd ${WKDIR}/SCRIPTS && sudo /bin/sh dnshost.sh ; bash\"" \
        --tab  -T "${_DNSHOST_name}" -e "bash -c \"cd ${WKDIR}/SCRIPTS && sleep 2 && (. ./vm_envs.sh;telnet -4  localhost ${_DNSHOST_telnetport}); bash\""
  return
}

external1_vm () {
  # external1
  echo "in function: [${_EXTERNAL1_telnetport}]"
  xfce4-terminal --window --geometry="80x24+75+75" --zoom="-1" \
               -T "${_EXTERNAL1_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sudo /bin/sh external1.sh ; bash\"" \
        --tab  -T "${_EXTERNAL1_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sleep 2 && (. ./vm_envs.sh;telnet localhost ${_EXTERNAL1_telnetport}); bash\""
  return
}

external2_vm () {
  # external2
  echo "in function: [${_EXTERNAL2_telnetport}]"
  xfce4-terminal --window --geometry="80x24+100+100" --zoom="-1" \
               -T "${_EXTERNAL2_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sudo /bin/sh external2.sh ; bash\"" \
        --tab  -T "${_EXTERNAL2_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sleep 2 && (. ./vm_envs.sh;telnet localhost ${_EXTERNAL2_telnetport}); bash\""
  return
}

external3_vm () {
  # external3
  echo "in function: [${_EXTERNAL3_telnetport}]"
  xfce4-terminal --window --geometry="80x24+125+125" --zoom="-1" \
               -T "${_EXTERNAL3_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sudo /bin/sh external3.sh ; bash\"" \
        --tab  -T "${_EXTERNAL3_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sleep 2 && (. ./vm_envs.sh;telnet localhost ${_EXTERNAL3_telnetport}); bash\""
  return
}

firewall_vm () {
  # Firewall
  echo "in function: [${_FIREWALL_telnetport}]"
  xfce4-terminal --window --geometry="80x24+150+150" --zoom="-1" \
               -T "${_FIREWALL_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sudo /bin/sh firewall.sh ; bash\"" \
        --tab  -T "${_FIREWALL_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sleep 2 && (. ./vm_envs.sh; telnet localhost ${_FIREWALL_telnetport}); bash\""
  return
}

firewall2_vm () {
  # Firewall2
  echo "in function: [${_FIREWALL2_telnetport}]"
  xfce4-terminal --window --geometry="80x24+175+175" --zoom="-1" \
               -T "${_FIREWALL2_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sudo /bin/sh firewall2.sh ; bash\"" \
        --tab  -T "${_FIREWALL2_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sleep 2 && (. ./vm_envs.sh;telnet localhost ${_FIREWALL2_telnetport}); bash\""
  return
}

internal_vm () {
  # internal
  echo "in function: [${_INTERNAL_telnetport}]"
  xfce4-terminal --window --geometry="80x24+200+200" --zoom="-1" \
               -T "${_INTERNAL_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sudo /bin/sh internal.sh ; bash\"" \
        --tab  -T "${_INTERNAL_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sleep 2 && (. ./vm_envs.sh;telnet localhost ${_INTERNAL_telnetport}); bash\""
  return
}

v6only_vm () {
  # v6only
  echo "in function: [${_V6ONLY_telnetport}]"
  xfce4-terminal --window --geometry="80x24+225+225" --zoom="-1" \
               -T "${_V6ONLY_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sudo /bin/sh v6only.sh ; bash\"" \
        --tab  -T "${_V6ONLY_name}" -e "bash -c \"cd $WKDIR/SCRIPTS && sleep 2 && (. ./vm_envs.sh;telnet localhost ${_V6ONLY_telnetport}); bash\""
  return
}


#
# Startup the requested VMs
#


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


