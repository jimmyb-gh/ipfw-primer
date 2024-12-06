#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for v6only VM.
#
# v6only.sh: FreeBSD QEMU VM startup script for v6only VM.
# Usage: sudo /bin/sh v6only.sh
# Note: Set up for serial console. Start another session and telnet to the port shown.
#
# FreeBSD QEMU VM startup script
#
# v6only.sh
#
#set -x

# pick up environment for this run
. ./vm_envs.sh


echo  [ISO=${_V6ONLY_ISO}]
echo  [mem=${_V6ONLY_mem}]
echo  [hdsize=${_V6ONLY_hdsize}]
echo  [img=${_V6ONLY_img}]
echo  [mac=${_V6ONLY_mac}]
echo  [name=${_V6ONLY_name}]
echo  [tap6=${_V6ONLY_tap6}]
echo  [telnetport=${_V6ONLY_telnetport}]

#exit

echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_V6ONLY_telnetport"  
echo 
#  -netdev tap,id=nd0,ifname=${_V6ONLY_tap5},script=no,downscript=no,br=${_bridge1_} \

/usr/local/bin/qemu-system-x86_64 -monitor none \
  -serial telnet:localhost:${_V6ONLY_telnetport},server \
  -cpu qemu64 \
  -vga cirrus \
  -m ${_V6ONLY_mem}      \
  -cdrom ${_V6ONLY_ISO}  \
  -boot order=cd,menu=on,splash=${_V6_splash},splash-time=3000 \
  -drive if=none,id=drive0,cache=none,aio=threads,format=raw,file=${_V6ONLY_img} \
  -device virtio-blk,drive=drive0  \
  -netdev tap,id=nd0,ifname=${_V6ONLY_tap6},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_V6ONLY_mac} \
  -name \"${_V6ONLY_name}\"


