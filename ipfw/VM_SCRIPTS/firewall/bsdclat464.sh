#!/bin/sh
# IPFW Primer
# License: 3-clause BSD 
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# FreeBSD 464XLAT CLAT script for firewall VM.
#
# bsdclat464.sh: FreeBSD IPFW script for 464XLAT CLAT.  See Section 6.2
# Usage: # /bin/sh bsdclat464.sh    (run script as root)

set -x

kldunload ipfw_nat64
kldunload ipfw
sleep 1
kldload ipfw
kldload ipfw_nat64

# Create the nat64clat instance
ipfw nat64clat CLAT create clat_prefix 2001:db8:aaaa::/96 plat_prefix 2001:db8:bbbb::/96 allow_private log

# Allow neighbor discovery
ipfw add 100 allow log icmp6 from any to any icmp6types 135,136

# pass any ip through the nat64clat instance
ipfw add 150 nat64clat CLAT log ip from any to any

# pass any ip through the nat64plat instance
ipfw add 200 nat64clat CLAT log ip from any to 2001:db8:bbbb::/96

# allow ipv6 from any to any
ipfw add 300 allow log ip6 from any to any

# allow ipv4 from any to any
ipfw add 400 allow log ip from any to any

# 0=log with ipfwlog0, 1=log with syslog
sysctl net.inet.ip.fw.verbose=0

sysctl net.inet.ip.fw.nat64_debug=1

# direct output: 1 enable, 0 disable (packet goes back into ruleset)
sysctl net.inet.ip.fw.nat64_direct_output=1



