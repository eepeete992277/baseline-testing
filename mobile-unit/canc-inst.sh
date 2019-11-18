#!/usr/bin/bash
#
# Dot-Net Core and Covenant Install script
# scanner-c&c install -- canc-inst.sh Version: .00
# Author:
# Date: 11/11/19

# Help Text

# Display ifconfig
ifconfig

# Ask for Scanner IP
read -p 'Scanner IP: ' scannerip

#install dotnet core and Covenant
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2

# Setup proxychains
sed -i '$ d' /etc/proxychains.conf
echo socks4 scannerip 1080 >> /etc/proxychains.conf

# Install Reponsder and reconfigure
sudo git clone https://github.com/lgandx/Responder.git /opt/Responder/
cp /opt/baseline-testing/autoMITM6/Responder.conf /opt/Responder/

# Install mitm6
sudo apt install python-pip -y && \
sudo git clone https://github.com/fox-it/mitm6.git /opt/mitm6/ && \
cd /opt/mitm6/ && \
sudo pip install -r requirements.txt && \
sudo python setup.py install

# Install impacket
sudo git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket/ && \
cd /opt/impacket/ && \
sudo pip install .

git clone --recurse-submodules https://github.com/cobbr/Covenant
cd Covenant/Covenant
dotnet build
dotnet run

echo -e "\e[1;33mGet PS Payload from Covenant and enter below:\e[0m"
echo "Paste your powershell payload"
echo " ctrl-d when done"
var=$(cat)
echo $var >> pay1.ps1
echo "running simpleHTTPserverpythonscript"
echo "ntlmrelayx -wh -6 -x $var'"
