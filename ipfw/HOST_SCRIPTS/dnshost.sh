#!/bin/sh
# IPFW Primer
# License: 3-clause BSD 
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM startup script for dnshost VM.
#
# dnshost.sh: FreeBSD QEMU VM startup script for dnshost VM.
# Usage: sudo /bin/sh dnshost.sh 
# Note: Set up for serial console. Start another session and telnet to the port shown.
#
#set -x

# pick up environment for this run
. ./vm_envs.sh

echo [ISO=${_DNSHOST_ISO}]
echo [mem=${_DNSHOST_mem}]
echo [hdsize=${_DNSHOST_hdsize}]
echo [img=${_DNSHOST_img}]
echo [mac1=${_DNSHOST_mac1}]
echo [mac2=${_DNSHOST_mac2}]
echo [name=${_DNSHOST_name}]
echo [tap7=${_DNSHOST_tap7}]
echo [tap8=${_DNSHOST_tap8}]
echo [tap11=${_DNSHOST_tap11}]
echo [telnetport=${_DNSHOST_telnetport}]

#exit

# Note - the dnshost has two interfaces - em0 and em1.
#        em0 is considered the ipv4 interface and
#        em1 is considered the ipv6 interface.

echo 
echo "NOTE!!! telnet server running!  To start QEMU telnet to localhost $_DNSHOST_telnetport"  
echo 

/usr/local/bin/qemu-system-x86_64  -monitor stdio \
  -serial telnet:localhost:${_DNSHOST_telnetport},server=on,wait=on \
  -cpu qemu64 \
  -vga std \
  -m ${_DNSHOST_mem}      \
  -cdrom ${_DNSHOST_ISO}  \
  -boot order=cd,menu=on,splash=${_DNS_splash},splash-time=3000 \
  -blockdev driver=file,aio=threads,node-name=imgleft,filename=${_DNSHOST_img} \
  -blockdev driver=qcow2,node-name=drive0,file=imgleft \
  -device virtio-blk-pci,drive=drive0,bootindex=1 \
  -netdev tap,id=nd0,ifname=${_DNSHOST_tap7},script=no,downscript=no \
  -device e1000,netdev=nd0,mac=${_DNSHOST_mac1} \
  -netdev tap,id=nd1,ifname=${_DNSHOST_tap8},script=no,downscript=no \
  -device e1000,netdev=nd1,mac=${_DNSHOST_mac2} \
  -netdev tap,id=nd2,ifname=${_DNSHOST_tap11},script=no,downscript=no \
  -device e1000,netdev=nd2,mac=${_DNSHOST_mac3} \
  -name \"${_DNSHOST_name}\"


