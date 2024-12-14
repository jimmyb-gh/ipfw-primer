#!/bin/sh
# FreeBSD qemu vm startup script
#
# jail1.sh
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


echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_JAIL1_telnetport"  
echo 

/usr/local/bin/qemu-system-x86_64 -monitor stdio \
  -serial telnet:localhost:${_JAIL1_telnetport},server=on,wait=on \
  -cpu qemu64 \
  -vga cirrus \
  -m ${_JAIL1_mem}      \
  -cdrom ${_JAIL1_ISO}  \
  -boot order=cd,menu=on,splash=${_JAIL1_splash},splash-time=3000 \
  -drive if=none,id=drive0,cache=none,aio=threads,format=raw,file=${_JAIL1_img} \
  -device virtio-blk,drive=drive0  \
  -netdev tap,id=nd0,ifname=${_JAIL1_tap12},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_JAIL1_mac} \
  -name \"${_JAIL1_name}\"



