# Wazuh-3.10-installer-Debian-Ubuntu

Edit: 29-09-2019

DO NOT USE, IT'S NOT FINISHED YET. Testing is ok though! :-)

This simple script will install Single-Host Wazuh 3.10.2 + ELK stack on Debian 9 server or Ubuntu 18.04 server (tested) Please make sure your server has enough RAM (I advise 16GB minimum for production) or the installation may fail.

I will add a reverse proxy at a later time.

This is a work in progress.

Installation:

sudo -i

apt install git -y && git clone https://github.com/diagonalciso/wazuh-installer.git && cd wazuh-installer && chmod +x wazuh.sh && ./wazuh.sh

There will be a few questions, please answer them when prompted. When done, login under https://ip-address:5601 :-)
