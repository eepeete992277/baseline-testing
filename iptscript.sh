#!/usr/bin/env bash
#
# This script will allow you to preform many
# of the mundane tasks of an internal peenetration test
#
# iPeen.sh Version: 2.63
# Author: Maleick
# Date: 10/22/19

# Help Text
echo
echo -e "\e[1;33mUsage: $0 iplist.txt exclusions.txt\e[0m"
echo

# Dependency check to create program banner (figlet)
if [ $(dpkg-query -W -f='${Status}' figlet 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt install figlet -y;
fi

# Program banner
figlet iPeen v2.62
echo
echo -e "\e[1;31mThe Internal Peentration Tester\e[0m"
echo

# Nmap Host discovery
echo -e "\e[1;33mRunning Nmap Host Discovery\e[0m"
nmap -sn -T4 -iL $1 --excludefile $2 -oG NmapHostDiscovery

sleep 5

# Build hosts file for Nmap TCP Scanning
awk '/Up/{print $2}' < NmapHostDiscovery > hosts

sleep 5

# Nmap TCP Scan
echo -e "\e[1;33mRunning Nmap TCP Port Scanning\e[0m"
nmap -sS -T4 -iL hosts --top-ports 300 -oG tcp.gnmap -v

# Nmap UDP Scan
echo -e "\e[1;33mRunning Nmap UDP Port Scanning\e[0m"
nmap -sU -T4 -iL hosts --top-ports 100 -oG udp.gnmap -v

# Creates files for open ports
echo -e "\e[1;33mParsing Open Ports\e[0m"
/opt/iPeen/NmapTools/NmapParser.py

# URl File Creation
echo -e "\e[1;33mParsing Urls\e[0m"
awk '/ 80\/open/{print "http://" $2 ":80"}' < tcp.gnmap > urls
awk '/ 443\/open/{print "https://" $2 ":443"}' < tcp.gnmap >> urls
awk '/ 8080\/open/{print "http://" $2 ":8080"}' < tcp.gnmap >> urls
awk '/ 8443\/open/{print "http://" $2 ":8443"}' < tcp.gnmap >> urls

# Check for Anonymous Shares
cme smb ports/445 -u '' -p '' --shares | tee cme_anon
for i in $(cat ftp-hosts.txt); do echo $i; curl ftp://$i/ --max-time 30; echo ""; done | tee ftp-scan.txt

# Check for Anonymous Domain Enumeration
echo -e "\e[1;33mTesting Anonomous Domain Enumeration\e[0m"
for i in $(cat ports/389); do rpcclient -U "" -N -c enumdomusers $i > enumdom$i ; done

mkdir DomEnum

sleep 5

mv enumdom* DomEnum

# FTP Scanning
echo -e "\e[1;33mRunning FTP Scanning\e[0m"
for i in $(cat ports/21); do curl --connect-timeout 30 ftp://$i/ | tee ftpscan$i; done

mkdir FTP

sleep 5

mv ftpscan* FTP

# EyeWitness or Aquatone for Web Applications
echo -e "\e[1;33mRunning EyeWitness\e[0m"
/opt/EyeWitness/EyeWitness.py -f urls --web
cat urls | /opt/aquatone

# Create Logs Directory
mkdir logs

# Run Metasploit Modules based on MSFenum.rc
echo -e "\e[1;33mRunning Metasploit\e[0m"
msfconsole -r /opt/iPeen/MSFenum.rc



# Done
echo -e "\e[1;31mDone!\e[0m"
