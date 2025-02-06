#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for internal VM.
#
# internal.sh: FreeBSD QEMU VM startup script for internal VM.
# Usage: sudo /bin/sh internal.sh
# Note: Set up for serial console. Start another session and telnet to the port shown.
#
# FreeBSD QEMU VM startup script
#
# internal.sh
#
#set -x

# pick up environment for this run
. ./vm_envs.sh


echo [ISO=${_INTERNAL_ISO}]
echo [mem=${_INTERNAL_mem}]
echo [hdsize=${_INTERNAL_hdsize}]
echo [img=${_INTERNAL_img}]
echo [mac=${_INTERNAL_mac}]
echo [name=${_INTERNAL_name}]
echo [tap5=${_INTERNAL_tap5}]
echo [telnetport=${_INTERNAL_telnetport}]

#exit

echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_INTERNAL_telnetport"  
echo 
#  -netdev tap,id=nd0,ifname=${_INTERNAL_tap5},script=no,downscript=no,br=${_bridge1_} \


/usr/local/bin/qemu-system-x86_64 -monitor none \
  -serial telnet:localhost:${_INTERNAL_telnetport},server=on,wait=off \
  -cpu qemu64 \
  -vga cirrus \
  -m ${_INTERNAL_mem}      \
  -cdrom ${_INTERNAL_ISO}  \
  -boot order=cd,menu=on,splash=${_INT_splash},splash-time=3000 \
  -blockdev driver=file,aio=threads,node-name=imgleft,filename=${_INTERNAL_img} \
  -blockdev driver=qcow2,node-name=drive0,file=imgleft \
  -device virtio-blk-pci,drive=drive0,bootindex=1 \
  -netdev tap,id=nd0,ifname=${_INTERNAL_tap5},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_INTERNAL_mac} \
  -name \"${_INTERNAL_name}\"  &


