# Wazuh-3.10-installer for Debian and Ubuntu

Edit: 12-10-2019 (October 12)

This simple script will install Single-Host Wazuh 3.10.2 + ELK stack on Debian 9 server or Ubuntu 18.04 server (tested), in under 10 minutes on a reasonable server.
Please make sure your server has enough RAM (I advise 16GB minimum for production) or the installation may fail.

I used https://wazuh.com/start/ as a guide for building this installer. (For Debian from packages).
You'll find additional resources there too.

I might need to cleanup this script a bit, but for now it just works (at least for me).

Installation:

sudo -i

apt install git -y && git clone https://github.com/diagonalciso/Wazuh-3.10-installer.git && cd Wazuh-3.10-installer
 && chmod +x wazuh.sh && ./wazuh.sh

There will be a few questions, please answer them when prompted. 
When done, wait for 2 minutes and browse to https://ip-address/ (Until then you might get an error, just be patient)

"Regex can be a pain in the butt, but it's total fun working with"
