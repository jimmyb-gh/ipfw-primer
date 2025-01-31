#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for jail1 VM.
#
# jail1.sh: FreeBSD QEMU VM startup script for v6only VM.
# Usage: sudo /bin/sh jail1.sh
# Note: Set up for serial console. Start another session and telnet to the port
shown.
# 
# FreeBSD QEMU VM startup script
# 
# v6only.sh
#  
#set -x

# pick up environment for this run
. ./vm_envs.sh

echo [ISO=${_JAIL1_ISO}]
echo [mem=${_JAIL1_mem}]
echo [hdsize=${_JAIL1_hdsize}]
echo [img=${_JAIL1_img}]
echo [mac=${_JAIL1_mac}]
echo [name=${_JAIL1_name}]
echo [tap2=${_JAIL1_tap2}]
echo [telnetport=${_JAIL1_telnetport}]

#
#exit
#

# minimal check that environment is sane
#if [ "X${_FBSD_ISO}" = "X" -o  ! -s ${_FBSD_ISO} ]
#then 
#  echo "Parameter or file failure on _FBSD_ISO [${_FBSD_ISO}]"
#  echo "Check vm_envs.sh"
#  exit 1
#fi
#
#  -localtime \
#
#  -netdev tap,id=nd0,fd=h,ifname=${_JAIL1_tap1},script=no,downscript=no,br=${_bridge0_} \
#  -device e1000,netdev=nd0,mac=${_JAIL1_mac} \
#


#echo 
#echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_JAIL1_telnetport"  
#echo 

/usr/local/bin/qemu-system-x86_64 -monitor stdio \
  -serial telnet:localhost:${_JAIL1_telnetport},server=on,wait=on \
  -cpu qemu64 \
  -vga cirrus \
  -m ${_JAIL1_mem}      \
  -cdrom ${_JAIL1_ISO}  \
  -boot order=cd,menu=on,splash=${_JAIL1_splash},splash-time=3000 \
  -blockdev driver=file,aio=threads,node-name=imgleft,filename=${_JAIL1_img} \
  -blockdev driver=qcow2,node-name=drive0,file=imgleft \
  -device virtio-blk-pci,drive=drive0,bootindex=1 \
  -netdev tap,id=nd0,ifname=${_JAIL1_tap12},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_JAIL1_mac} \
  -name \"${_JAIL1_name}\"


