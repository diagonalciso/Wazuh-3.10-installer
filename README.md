# Wazuh-3.10-installer for Debian and Ubuntu

Edit: 3-10-2019 (October 3)

DO NOT USE, IT'S NOT FINISHED YET. Testing is ok though! :-)

This simple script will install Single-Host Wazuh 3.10.2 + ELK stack on Debian 9 server or Ubuntu 18.04 server (tested) Please make sure your server has enough RAM (I advise 16GB minimum for production) or the installation may fail.

I will add a reverse proxy at a later time.
Edit: Proxy added but it has some issues. Comment out "exit" on line 85 if you want to troubleshoot the NGINX proxy.

This is a work in progress.

Current status:
- Reverse proxy has some issues
- I am working on reducing user input as much as I can
- I will reduce the 5 minutes sleep cycles in the script by wathing output of some checks.

ERR: sed -i 's/^#cluster.initial_master_nodes: ["node-1", "node-2"]/cluster.initial_master_nodes: ["node-1"]/' /file

char 96: Invalid range end

I am not a programmer, this will take time (also spare time is an issue)

Installation:

sudo -i

apt install git -y && git clone https://github.com/diagonalciso/Wazuh-3.10-installer.git && cd Wazuh-3.10-installer
 && chmod +x wazuh.sh && ./wazuh.sh

There will be a few questions, please answer them when prompted. When done, login under https://ip-address/ :-)
