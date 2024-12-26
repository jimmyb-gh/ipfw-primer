#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for external1 VM.
#
# external1.sh: FreeBSD QEMU VM startup script for external1 VM.
# Usage: sudo /bin/sh external1.sh
# Note: Set up for serial console. Start another session and telnet to the port shown.
#
# FreeBSD QEMU VM startup script
#
# external1.sh
#
#set -x

# pick up environment for this run
. ./vm_envs.sh

echo [$_EXTERNAL1_ISO]
echo [$_EXTERNAL1_mem]
echo [$_EXTERNAL1_hdsize]
echo [$_EXTERNAL1_img]
echo [$_EXTERNAL1_mac]
echo [$_EXTERNAL1_name]
echo [$_EXTERNAL1_tap1]
echo [$_EXTERNAL1_telnetport]

#exit

echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_EXTERNAL1_telnetport"  
echo 

/usr/local/bin/qemu-system-x86_64 -monitor stdio \
  -serial telnet:localhost:${_EXTERNAL1_telnetport},server=on,wait=on \
  -cpu qemu64 \
  -vga cirrus \
  -m ${_EXTERNAL1_mem}      \
  -cdrom ${_EXTERNAL1_ISO}  \
  -boot order=cd,menu=on,splash=${_EX1_splash},splash-time=3000 \
  -drive if=none,id=drive0,cache=none,aio=threads,format=qcow2,file=${_EXTERNAL1_img} \
  -device virtio-blk,drive=drive0  \
  -netdev tap,id=nd0,ifname=${_EXTERNAL1_tap1},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_EXTERNAL1_mac} \
  -name \"${_EXTERNAL1_name}\"

