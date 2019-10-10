# Wazuh-3.10-installer for Debian and Ubuntu

Edit: 10-10-2019 (October 10)

This simple script will install Single-Host Wazuh 3.10.2 + ELK stack on Debian 9 server or Ubuntu 18.04 server (tested) Please make sure your server has enough RAM (I advise 16GB minimum for production) or the installation may fail.

I will add a reverse proxy at a later time.
Edit: Proxy added but it has some issues. Comment out "exit" on line 85 if you want to troubleshoot the NGINX proxy.

This is a work in progress.

Current status:
- Script is working, but the reverse proxy has not been implementet yet. so don't expose your server to the internet!

I am not a programmer, this will take time (also spare time is an issue)

Installation:

sudo -i

apt install git -y && git clone https://github.com/diagonalciso/Wazuh-3.10-installer.git && cd Wazuh-3.10-installer
 && chmod +x wazuh.sh && ./wazuh.sh

There will be a few questions, please answer them when prompted. 
When done, wait for 2 minutes and browse to http://ip-address:5601
