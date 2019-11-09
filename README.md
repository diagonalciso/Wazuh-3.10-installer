# Wazuh-3.10-installer for Debian 9 and Ubuntu 18.04 #

This simple script will install Single-Host Wazuh 3.10.2 + ELK stack on Debian 9 server or Ubuntu 18.04 server (tested).

Please make sure your server has enough RAM (I advise 16GB minimum for production) or the installation may fail.

I used https://wazuh.com/start/ as a guide for building this installer. (For Debian, from packages).
You'll find additional resources there too.

Installation:

sudo -i

apt install git -y && git clone https://github.com/diagonalciso/Wazuh-3.10-installer.git && cd Wazuh-3.10-installer
 && chmod +x wazuh.sh && ./wazuh.sh

There will be a few questions, please answer them when prompted. 
When done, wait for 2 minutes and browse to https://ip-address/ (Until then you might get an error, just be patient)

Found any bugs? Please drop me a line.

"Regex can be a pain in the butt, but it's total fun working with"
