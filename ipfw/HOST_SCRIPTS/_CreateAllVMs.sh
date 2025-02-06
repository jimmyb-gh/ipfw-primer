#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# _CreateAllVM.sh : Create VMs for the IPFW Primer lab.  Files are created in ../VM/
#

echo "Running _CreateAllVMs.sh"

echo 
echo "This script will create 8 virtual machines in ../VM/"
echo
read -p "DO YOU REALLY WANT TO CREATE NEW QEMU IMAGES OVERWRITING ANY EXISTING IMAGES? Answer YES to continue. " junk
echo [${junk}]

if [ "X${junk}" !=  "XYES" ]
then
  echo "Response was [${junk}]"
  echo "bailing out..."
  exit 1
fi

echo "Response was [${junk}]"
echo "Ok, continuing..."

#exit


for i in dnshost external1 external2 external3 firewall firewall2 internal v6only
do
  echo "Creating ${i} VM"
  echo qemu-img create -f qcow2 -o preallocation=full ../VM/${i}.qcow2 4G
  qemu-img create -f qcow2 -o preallocation=full ../VM/${i}.qcow2 4G
done


echo "Creating jail1 VM"
echo qemu-img create -f qcow2 -o preallocation=full ../VM/jail1.qcow2 G
qemu-img create -f qcow2 -o preallocation=full ../VM/jail1.qcow2 12G

echo
echo "Done."

exit
