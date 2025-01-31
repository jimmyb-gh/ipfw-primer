README.txt

The file "IPFW_root_bin.tgz" contains common scripts that should be downloaded
to all VMs.

1. Download IPFW_root_bin.tgz to the /root folder on the VM

2. Untar the file with:  tar xvzf IPFW_root_bin.tgz

3. Make the script files executable:  find . -name "*.sh" -exec chmod 755 {} \;


Each directory also contains an "index.html" file that should be copied to
/usr/local/www/nginx-dist on its respective virtual machine.




