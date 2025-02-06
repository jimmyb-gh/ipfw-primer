#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for firewall VM.
#
# firewall.sh: FreeBSD QEMU VM startup script for firewall VM.
# Usage: sudo /bin/sh firewall.sh
# Note: Set up for serial console. Start another session and telnet to the port shown.
#
# FreeBSD QEMU VM startup script
#
# firewall.sh
#
#set -x

# pick up environment for this run
. ./vm_envs.sh

echo [$_FIREWALL_ISO]
echo [$_FIREWALL_mem]
echo [$_FIREWALL_hdsize]
echo [$_FIREWALL_img]
echo [$_FIREWALL_mac1]
echo [$_FIREWALL_mac2]
echo [$_FIREWALL_name]
echo [$_FIREWALL_tap0]
echo [$_FIREWALL_tap4]
echo [$_FIREWALL_telnetport]

#exit


# Note - the firewall has two interfaces - em0 and em1.
#        em0 is considered the 'external' interface and
#        em1 is considered the 'internal' interface.

echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_FIREWALL_telnetport "  
echo 

/usr/local/bin/qemu-system-x86_64 -monitor none \
  -serial telnet:localhost:${_FIREWALL_telnetport},server=on,wait=off \
  -cpu qemu64 \
  -display gtk \
  -vga cirrus \
  -m ${_FIREWALL_mem}      \
  -cdrom ${_FIREWALL_ISO}  \
  -boot order=cd,menu=on,splash=${_FW_splash},splash-time=3000 \
  -blockdev driver=file,aio=threads,node-name=imgleft,filename=${_FIREWALL_img} \
  -blockdev driver=qcow2,node-name=drive0,file=imgleft \
  -device virtio-blk-pci,drive=drive0,bootindex=1 \
  -netdev tap,id=nd0,ifname=${_FIREWALL_tap0},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_FIREWALL_mac1} \
  -netdev tap,id=nd1,ifname=${_FIREWALL_tap4},script=no,downscript=no \
  -device e1000,netdev=nd1,mac=${_FIREWALL_mac2} \
  -name \"${_FIREWALL_name}\"   &


