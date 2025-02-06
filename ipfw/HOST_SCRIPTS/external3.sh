#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for external3 VM.
#
# external3.sh: FreeBSD QEMU VM startup script for external3 VM.
# Usage: sudo /bin/sh external3.sh
# Note: Set up for serial console. Start another session and telnet to the port shown.
#
# FreeBSD QEMU VM startup script
#
# external3.sh
#
#set -x

# pick up environment for this run
. ./vm_envs.sh

echo [ISO=${_EXTERNAL3_ISO}]
echo [mem=${_EXTERNAL3_mem}]
echo [hdsize=${_EXTERNAL3_hdsize}]
echo [img=${_EXTERNAL3_img}]
echo [mac=${_EXTERNAL3_mac}]
echo [name=${_EXTERNAL3_name}]
echo [tap3=${_EXTERNAL3_tap3}]
echo [telnetport=${_EXTERNAL3_telnetport}]

#exit

echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_EXTERNAL3_telnetport"  
echo 

/usr/local/bin/qemu-system-x86_64 -monitor none \
  -serial telnet:localhost:${_EXTERNAL3_telnetport},server=on,wait=off \
  -cpu qemu64 \
  -vga cirrus \
  -m ${_EXTERNAL3_mem}      \
  -cdrom ${_EXTERNAL3_ISO}  \
  -boot order=cd,menu=on,splash=${_EX3_splash},splash-time=3000 \
  -blockdev driver=file,aio=threads,node-name=imgleft,filename=${_EXTERNAL3_img} \
  -blockdev driver=qcow2,node-name=drive0,file=imgleft \
  -device virtio-blk-pci,drive=drive0,bootindex=1 \
  -netdev tap,id=nd0,ifname=${_EXTERNAL3_tap3},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_EXTERNAL3_mac} \
  -name \"${_EXTERNAL3_name}\"  &

