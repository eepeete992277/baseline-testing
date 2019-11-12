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
/pathtonmap-grep.sh

# Run Metasploit Modules based on MSFenum.rc
echo -e "\e[1;33mRunning Metasploit\e[0m"
msfconsole -r /pathtometasploit.rc
