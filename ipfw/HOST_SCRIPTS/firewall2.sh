#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for firewall2 VM.
#
# firewall2.sh: FreeBSD QEMU VM startup script for firewall2 VM.
# Usage: sudo /bin/sh firewall2.sh
# Note: Set up for serial console. Start another session and telnet to the port shown.
#
# FreeBSD QEMU VM startup script
#
# firewall2.sh
#
#set -x

# pick up environment for this run
. ./vm_envs.sh

echo [ISO=${_FIREWALL2_ISO}]
echo [mem=${_FIREWALL2_mem}]
echo [hdsize=${_FIREWALL2_hdsize}]
echo [img=${_FIREWALL2_img}]
echo [mac1=${_FIREWALL2_mac1}]
echo [mac2=${_FIREWALL2_mac2}]
echo [name=${_FIREWALL2_name}]
echo [tap9=${_FIREWALL2_tap9}]
echo [tap10=${_FIREWALL2_tap10}]
echo [telnetport=${_FIREWALL2_telnetport}]

#exit

# Note - the firewall has two interfaces - em0 and em1.
#        em0 is considered the 'external' interface and
#        em1 is considered the 'internal' interface.

echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_FIREWALL2_telnetport"  
echo 

/usr/local/bin/qemu-system-x86_64 -monitor none \
  -serial telnet:localhost:${_FIREWALL2_telnetport},server=on,wait=off \
  -cpu qemu64 \
  -display gtk \
  -vga cirrus \
  -m ${_FIREWALL2_mem}      \
  -cdrom ${_FIREWALL_ISO}  \
  -boot order=cd,menu=on,splash=${_FW2_splash},splash-time=3000 \
  -blockdev driver=file,aio=threads,node-name=imgleft,filename=${_FIREWALL2_img} \
  -blockdev driver=qcow2,node-name=drive0,file=imgleft \
  -device virtio-blk-pci,drive=drive0,bootindex=1 \
  -netdev tap,id=nd0,ifname=${_FIREWALL2_tap9},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_FIREWALL2_mac1} \
  -netdev tap,id=nd1,ifname=${_FIREWALL2_tap10},script=no,downscript=no \
  -device e1000,netdev=nd1,mac=${_FIREWALL2_mac2} \
  -name \"${_FIREWALL2_name}\"   &


