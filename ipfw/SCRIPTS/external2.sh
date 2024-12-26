#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for external2 VM.
#
# external2.sh: FreeBSD QEMU VM startup script for external2 VM.
# Usage: sudo /bin/sh external2.sh
# Note: Set up for serial console. Start another session and telnet to the port shown.
#

# FreeBSD qemu vm startup script
#
# external2.sh
#
#set -x

# pick up environment for this run
. ./vm_envs.sh

echo [ISO=${_EXTERNAL2_ISO}]
echo [mem=${_EXTERNAL2_mem}]
echo [hdsize=${_EXTERNAL2_hdsize}]
echo [img=${_EXTERNAL2_img}]
echo [mac=${_EXTERNAL2_mac}]
echo [name=${_EXTERNAL2_name}]
echo [tap2=${_EXTERNAL2_tap2}]
echo [telnetport=${_EXTERNAL2_telnetport}]

#exit

echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_EXTERNAL2_telnetport"  
echo 

/usr/local/bin/qemu-system-x86_64 -monitor stdio \
  -serial telnet:localhost:${_EXTERNAL2_telnetport},server=on,wait=on \
  -cpu qemu64 \
  -vga cirrus \
  -m ${_EXTERNAL2_mem}      \
  -cdrom ${_EXTERNAL2_ISO}  \
  -boot order=cd,menu=on,splash=${_EX2_splash},splash-time=3000 \
  -drive if=none,id=drive0,cache=none,aio=threads,format=qcow2,file=${_EXTERNAL2_img} \
  -device virtio-blk,drive=drive0  \
  -netdev tap,id=nd0,ifname=${_EXTERNAL2_tap2},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_EXTERNAL2_mac} \
  -name \"${_EXTERNAL2_name}\"


