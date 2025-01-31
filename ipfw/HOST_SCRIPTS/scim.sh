#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# Serial Window Management Script Using screen. (scim.sh)
#
# Usage: /bin/sh scim.sh
# Note: This program manages multiple serial termainal windows for QEMU VMs.
#       Make sure to uncomment the lines below for the windows you want.
#
# Note:
# In order to show the status line for the list of active windows,
# this program requires a .screenrc file in the $HOME directory with
# the following directives:
#
# hardstatus alwayslastline
# hardstatus string "%{= bw}%-w%{= rW}[%n %t]%{-}%+w %=%{= kW} %H | %Y-%m-%d %c"
#

screen -list  2> /dev/null

# Check if the session is already live
if [ $? != 0 ]; then

  # Create a new session and add windows
  screen -dmS newsession          # Start a new session

  # Uncomment windows as needed.
  screen -S newsession -X screen -t "firewall"  sh -c "echo; echo Use \"telnet localhost 4450\" for firewall  ; echo; /bin/sh"
  screen -S newsession -X screen -t "external1" sh -c "echo; echo Use \"telnet localhost 4410\" for external1 ; echo; /bin/sh"
  screen -S newsession -X screen -t "external2" sh -c "echo; echo Use \"telnet localhost 4420\" for external1 ; echo; /bin/sh"
  screen -S newsession -X screen -t "external3" sh -c "echo; echo Use \"telnet localhost 4430\" for external1 ; echo; /bin/sh"
#  screen -S newsession -X screen -t "internal"  sh -c "echo; echo Use \"telnet localhost 44200\" for external1 ; echo; /bin/sh"
#  screen -S newsession -X screen -t "firewall2" sh -c "echo; echo Use \"telnet localhost 4250\" for external1 ; echo; /bin/sh"
#  screen -S newsession -X screen -t "v6only"    sh -c "echo; echo Use \"telnet localhost 4460\" for external1 ; echo; /bin/sh"
#  screen -S newsession -X screen -t "dnshost"   sh -c "echo; echo Use \"telnet localhost 4453\" for external1 ; echo; /bin/sh"
#  screen -S newsession -X screen -t "jail1"     sh -c "echo; echo Use \"telnet localhost 4470\" for external1 ; echo; /bin/sh"

# Focus on window 0
  screen -S newsession -X select 0
fi

# Light it up.
screen -x newsession  -p 0

