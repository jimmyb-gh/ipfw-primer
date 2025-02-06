# ipfw-primer
Scripts and code to use with the IPFW Primer book.

Directories:
- *BMP* - splash files for the virtual machines
- *HOST_SCRIPTS* - scripts necessary for setting up the host
- *VM_SCRIPTS* - scripts used on the VMs
- *VM_CODE* - code for the divert.c program on the firewall VM.

Directions:
1. Download the HOST_SCRIPTS onto the FreeBSD Host
1. Use the scripts to create and set up the virtual machines (see text).
1. On each virtual machine, download VM_SCRIPTS and untar into /root
1. On the *firewall* VM, download the VM_CODE/divert.c code and build it (see text).
1. Optional - Download the BMP files to the location assigned in the VM startup scripts.


```
.
|-- LICENSE
|-- README.md
`-- ipfw
    |-- BMP
    |   |-- dns_splash_640x480.bmp
    |   |-- external1_splash_640x480.bmp
    |   |-- external2_splash_640x480.bmp
    |   |-- external3_splash_640x480.bmp
    |   |-- internal_splash_640x480.bmp
    |   |-- ipfw2_splash_640x480.bmp
    |   |-- ipfw_splash_640x480.bmp
    |   |-- ipv6_splash_640x480.bmp
    |   `-- jail1_splash_640x480.bmp
    |-- HOST_SCRIPTS
    |   |-- TAPLIST.TXT
    |   |-- _CreateAllVMs.sh
    |   |-- dnshost.sh
    |   |-- external1.sh
    |   |-- external2.sh
    |   |-- external3.sh
    |   |-- firewall.sh
    |   |-- firewall2.sh
    |   |-- internal.sh
    |   |-- jail1.sh
    |   |-- mkbr.sh
    |   |-- runvm.sh
    |   |-- scim.sh
    |   |-- swim.sh
    |   |-- v6only.sh
    |   `-- vm_envs.sh
    |-- VM_CODE
    |   `-- divert.c
    `-- VM_SCRIPTS
        |-- IPFW_root_bin.tgz
        |-- Manifest_IPFW_root_bin.txt
        |-- Manifest_index.txt
        |-- README.txt
        |-- bin
        |   |-- tcon.sh
        |   |-- tconr.sh
        |   |-- tcont.sh
        |   |-- tserv.sh
        |   |-- tserv3.sh
        |   |-- ucon.sh
        |   |-- uconr.sh
        |   |-- ucont.sh
        |   |-- userv.sh
        |   |-- userv3.sh
        |   `-- userv5.sh
        |-- dnshost
        |   |-- Manifest_namedb.txt
        |   |-- dnshost_usrlocaletc_namedb.tgz
        |   `-- index.html
        |-- external1
        |   `-- index.html
        |-- external2
        |   `-- index.html
        |-- external3
        |   `-- index.html
        |-- firewall
        |   |-- bsdclat464.sh
        |   `-- index.html
        |-- firewall2
        |   |-- bsdplat464.sh
        |   `-- index.html
        |-- internal
        |   `-- index.html
        |-- jail1
        |   `-- index.html
        `-- v6only
            `-- index.html
```

