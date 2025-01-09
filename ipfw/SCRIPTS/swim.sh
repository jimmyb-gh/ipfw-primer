#!/bin/sh
# IPFW Primer
# License: 3-clause BSD
# Author: Jim Brown, jpb@jimby.name
# Code: https://github.com/jimmyb-gh/ipfw-primer
#
# Serial Window Management Script Using tmux. (swim.sh)
#
# Usage: /bin/sh swim.sh
# Note: This program manages multiple serial termainal windows for QEMU
#       VMs on the host.
#       Make sure to uncomment the lines below for the windows you want.
#set -x

# Check for an existing tmux session
tmux has-session -t 0 2>/dev/null

if [ $? != 0 ]; then
  tmux new-session -d -s 0

  tmux new-window  -t 0:1 -n 'firewall'  'echo; echo Use \"telnet localhost 4450\" for firewall ; echo; /bin/sh'
  tmux new-window  -t 0:2 -n 'external1' 'echo; echo Use \"telnet localhost 4410\" for external1; echo; /bin/sh'
  tmux new-window  -t 0:3 -n 'external2' 'echo; echo Use \"telnet localhost 4420\" for external2; echo; /bin/sh'
  tmux new-window  -t 0:4 -n 'external3' 'echo; echo Use \"telnet localhost 4430\" for external3; echo; /bin/sh'
#  tmux new-window  -t 0:5 -n 'internal'  'echo; echo Use \"telnet localhost 44200\" for internal; echo; /bin/sh'
#  tmux new-window  -t 0:6 -n 'firewall2' 'echo; echo Use \"telnet localhost 4250\" for firewall2; echo; /bin/sh'
#  tmux new-window  -t 0:7 -n 'v6only'    'echo; echo Use \"telnet localhost 4460\" for v6only;    echo; /bin/sh'
#  tmux new-window  -t 0:8 -n 'dnshost'   'echo; echo Use \"telnet localhost 4453\" for dnshost;   echo; /bin/sh'
#  tmux new-window  -t 0:9 -n 'jail1'     'echo; echo Use \"telnet localhost 4470\" for jail1;     echo; /bin/sh'

  # Set the default command shell
  set-option -g default-command "/bin/sh"
fi

# Set the focus on window 0:0, your existing shell.
tmux select-window -t 0:0

# Attach to the session
tmux attach-session -t 0

exit

