#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD 464XLAT PLAT script for firewall2 VM.
#
# bsdplat464.sh: FreeBSD IPFW script for 464XLAT CLAT.  See Section 6.2
# Usage: # /bin/sh bsdplat464.sh    (run script as root)

set -x

kldunload ipfw_nat64
kldunload ipfw

sleep 1

kldload ipfw
kldload ipfw_nat64

# create the nat64 stateful instance
ipfw nat64lsn NAT64 create log prefix4 203.0.112.0/24 prefix6 2001:db8:bbbb::/96 allow_private

# Allow neighbor discovery
ipfw add allow log icmp6 from any to any icmp6types 135,136

# Allow the nat64 outbound
ipfw add nat64lsn NAT64 log ip from 2001:db8:12::/64 to 2001:db8:bbbb::/96 in

ipfw add nat64lsn NAT64 log ip from any to 2001:db8:bbbb::/96 in

# Allow the nat64 inbound
ipfw add nat64lsn NAT64  log ip from any to 203.0.112.0/24 in

# Allow ipv4 from any to any
ipfw add allow log ip from any to any

# Allow ipv6 from any to any
ipfw add allow log ip6 from any to any

# Logging: 0 interfaces, 1 syslog
sysctl net.inet.ip.fw.verbose=0

# Debug nat64
sysctl net.inet.ip.fw.nat64_debug=1

# Direct output: 1 enable, 0 disable (packet goes  back into ruleset)
sysctl net.inet.ip.fw.nat64_direct_output=1


