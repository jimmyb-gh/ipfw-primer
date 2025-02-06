# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD QEMU VM environment script.
#
# vmenv.sh: FreeBSD QEMU VM environment setup script.
# Usage: ./bin/sh vmenv.sh
#
# vm_envs.sh - environment for setting up virtual machines
#              for the IPFW example lab.
#
# Set the environment variables below (or keep the defaults)
# Note that the default disk size for each virtual machine is
# 4GB - so all five VMs will take up about 32GB if you preallocate
# space.
#
# In brief:
#
#  Install FreeBSD on the host machine and update to latest patch level.
#  Install desktop software.
#  Install QEMU (latest)
#  Install nmap (needed for ncat)
#  Install sudo
#
#
#  The script mkbr.sh should be run before starting
#  the virtual machines.  mkbr.sh sets up the bridge and tap
#  devices needed by the VMs.
#
#  sudo /bin/sh  ./mkbr.sh reset bridge0 tap0 tap1 tap2 tap3 em0 bridge1 tap4 tap5
#
# This will set up the devices needed by QEMU.
#
#
#The file directory layout for the examples is:
#
#    ..../ipfw
#          /HOST_SCRIPTS
#              _CreateAllVMs.sh   (create Qemu disks images)
#              dnshost.sh         (run script for dns server VM)
#              external1.sh       (run scripts for external  VMs)
#              external2.sh                  "
#              external3.sh                  "
#              firewall.sh        (run script for firewall VM)
#              firewall2.sh       (run script for firewall2 VM)
#              internal.sh        (script to setup internal host)
#              v6only.sh          (run script for IPv6 only VM)
#              jail1.sh           (run script for VM with a jail)
#              mkbr.sh            (script to create bridge and tap devices)
#              vm_envs.sh         (script to manage all parameters)
#              runvm.sh           (script to manage all virtual machines)
#          /BMP
#              dns_splash_640x480.bmp
#              external1_splash_640x480.bmp
#              external2_splash_640x480.bmp
#              external3_splash_640x480.bmp
#              internal_splash_640x480.bmp
#              ipfw2_splash_640x480.bmp
#              ipfw_splash_640x480.bmp
#              v6only_splash_640x480.bmp
#              jail1_splash_640x480.bmp
#              dnshost_splash_640x480.bmp
#          /ISO
#              fbsd.iso           (latest FreeBSD install iso)
#          /VM
#              dnshost.qcow2        (Qemu disk image for dns host)
#              external1.qcow2      (Qemu disk image for external hosts)
#              external2.qcow2                  "
#              external3.qcow2                  "
#              firewall.qcow2       (Qemu disk image for firewall)
#              firewall2.qcow2      (Qemu disk image for firewall2)
#              internal.qcow2       (Qemu disk image for an internal host)
#              v6only.qcow2         (Qemu disk image for an ipv6only host)
#              jail1.qcow2          (Qemu disk image for an VM with a jail)
#          /VM_CODE
#              divert.c             (C source code for divert example)
#          /VM_SCRIPTS
#              (various)            (Scripts for use on VMs. See text.)
#
#
#  Start the VMs and install / test one at a time.
#
#    sudo /bin/sh firewall.sh
#    sudo /bin/sh firewall2.sh
#    sudo /bin/sh external1.sh
#    sudo /bin/sh external2.sh
#    sudo /bin/sh external3.sh
#    sudo /bin/sh internal.sh
#    sudo /bin/sh v6only.sh
#    sudo /bin/sh dnshost.sh
#    sudo /bin/sh jail1.sh
#
#  Each install should first utilize DHCP to get a valid IP address
#  After install, proceed to update FreeBSD with "freebsd-update fetch install"
#  Install packages:
#  Use whatever shell you prefer.  Bash is listed below.
#    Firewall   - pkg install bash cmdwatch lynx iperf3 nmap hping3 nginx
#    All others - pkg install bash cmdwatch lynx iperf3 nmap hping3 nginx
#    DNS host   - pkg install bind918  dual-dhclient bash cmdwatch lynx nginx
#                 (use latest bind9 package)
#
#  Reset all IP addresses for static usage:
#
#  Disable any host firewall (pf, ipfw, etc.) on the host. 
#           BE SURE this is Ok for your environment.
#
#  v6only  as needed
#  dnshost as needed
#

#export _BASE=/home/jpb/ipfw
# Make relocatable.
export _BASE=.
 
# Bridge and tap info
export _FIREWALL_tap0=tap0
export _EXTERNAL1_tap1=tap1
export _EXTERNAL2_tap2=tap2
export _EXTERNAL3_tap3=tap3
export _FIREWALL_tap4=tap4
export _INTERNAL_tap5=tap5
export _V6ONLY_tap6=tap6
export _DNSHOST_tap7=tap7
export _DNSHOST_tap8=tap8
export _FIREWALL2_tap9=tap9
export _FIREWALL2_tap10=tap10
export _DNSHOST_tap11=tap11
export _JAIL1_tap12=tap12

export _bridge0_=bridge0
export _bridge1_=bridge1
export _bridge2_=bridge2


# Disk sizes
export _EXTERNAL1_hdsize=4G
export _EXTERNAL2_hdsize=4G
export _EXTERNAL3_hdsize=4G
export _FIREWALL_hdsize=4G
export _FIREWALL2_hdsize=4G
export _INTERNAL_hdsize=4G
export _V6ONLY_hdsize=4G
export _DNSHOST_hdsize=4G
export _JAIL1_hdsize=12G

# Is this needed anymore?
export _FBSD_ISO=${_BASE}/ISO/fbsd.iso

# Boot iso locations
export _DNSHOST_ISO=${_BASE}/../ISO/fbsd.iso
export _EXTERNAL1_ISO=${_BASE}/../ISO/fbsd.iso
export _EXTERNAL2_ISO=${_BASE}/../ISO/fbsd.iso
export _EXTERNAL3_ISO=${_BASE}/../ISO/fbsd.iso
export _FIREWALL_ISO=${_BASE}/../ISO/fbsd.iso
export _FIREWALL2_ISO=${_BASE}/../ISO/fbsd.iso
export _INTERNAL_ISO=${_BASE}/../ISO/fbsd.iso
export _V6ONLY_ISO=${_BASE}/../ISO/fbsd.iso
export _JAIL1_ISO=${_BASE}/../ISO/fbsd.iso

# Memory sizes
export _DNSHOST_mem=1024
export _EXTERNAL1_mem=1024     # lower all to 512 if necessary
export _EXTERNAL2_mem=1024
export _EXTERNAL3_mem=1024
export _FIREWALL_mem=1024
export _FIREWALL2_mem=1024
export _INTERNAL_mem=1024
export _V6ONLY_mem=1024
export _JAIL1_mem=8192         # Note - larger memory for ZFS and jail


# Qemu disk image locations.
export _DNSHOST_img=${_BASE}/../VM/dnshost.qcow2
export _EXTERNAL1_img=${_BASE}/../VM/external1.qcow2
export _EXTERNAL2_img=${_BASE}/../VM/external2.qcow2
export _EXTERNAL3_img=${_BASE}/../VM/external3.qcow2
export _FIREWALL_img=${_BASE}/../VM/firewall.qcow2
export _FIREWALL2_img=${_BASE}/../VM/firewall2.qcow2
export _INTERNAL_img=${_BASE}/../VM/internal.qcow2
export _V6ONLY_img=${_BASE}/../VM/v6only.qcow2
export _JAIL1_img=${_BASE}/../VM/jail1.qcow2

# MAC addresses
export _DNSHOST_mac1=02:49:53:53:53:53
export _DNSHOST_mac2=02:49:53:53:54:54
export _DNSHOST_mac3=02:49:53:53:55:55
export _EXTERNAL1_mac=02:45:58:54:31:10
export _EXTERNAL2_mac=02:45:58:54:32:20
export _EXTERNAL3_mac=02:45:58:54:33:30
export _FIREWALL_mac1=02:49:50:46:57:41
export _FIREWALL2_mac1=02:49:50:00:22:22
export _FIREWALL_mac2=02:49:50:46:57:42
export _FIREWALL2_mac2=02:49:50:22:22:22
export _INTERNAL_mac=02:49:4E:54:0a:42
export _V6ONLY_mac=02:49:de:ad:be:ef
export _JAIL1_mac=02:49:ba:ad:ba:be

# VM names
export _DNSHOST_name=DNSHOST
export _EXTERNAL1_name=EXTERNAL1
export _EXTERNAL2_name=EXTERNAL2
export _EXTERNAL3_name=EXTERNAL3
export _FIREWALL_name=FIREWALL
export _FIREWALL2_name=FIREWALL2
export _INTERNAL_name=INTERNAL
export _V6ONLY_name=V6ONLY
export _JAIL1_name=JAIL1

# Slash images
export _DNS_splash=${_BASE}/../BMP/dns_splash_640x480.bmp
export _EX1_splash=${_BASE}/../BMP/external1_splash_640x480.bmp
export _EX2_splash=${_BASE}/../BMP/external2_splash_640x480.bmp
export _EX3_splash=${_BASE}/../BMP/external3_splash_640x480.bmp
export _FW_splash=${_BASE}/../BMP/ipfw_splash_640x480.bmp
export _FW2_splash=${_BASE}/../BMP/ipfw2_splash_640x480.bmp
export _INT_splash=${_BASE}/../BMP/internal_splash_640x480.bmp
export _V6_splash=${_BASE}/../BMP/ipv6_splash_640x480.bmp
export _JAIL1_splash=${_BASE}/../BMP/jail1_splash_640x480.bmp

#
# Telnet ports
export _DNSHOST_telnetport=4453
export _EXTERNAL1_telnetport=4410
export _EXTERNAL2_telnetport=4420
export _EXTERNAL3_telnetport=4430
export _FIREWALL_telnetport=4450
export _FIREWALL2_telnetport=4250
export _INTERNAL_telnetport=44200
export _V6ONLY_telnetport=4460
export _JAIL1_telnetport=4470


# Bridge and Tap configurations.
#
# Note: hostif is used for the host interface.
#       Change as needed.
#
# Two bridge configuration
# Standard examples
#
#                        hostif
#                         |
#  External1(tap1) -----bridge0------(tap0)Firewall
#  External2(tap2) -----+ |                  (tap4)
#  External3(tap3) -------+                    |
#                                            bridge1
#                                              |
#  Internal(tap5) -----------------------------+
#
#  sudo /bin/sh mkbr.sh reset bridge0 tap0 tap1 tap2 tap3 hostif bridge1 tap4 tap5
#
