#!/usr/bin/env bash
#
# This script will allow you to perform initial recon
#
#
# recon Version: 0.01
# Author: Even.r
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
figlet recon.sh v.zero.00
echo
echo -e "\e[1;31mRecon Recon Recon\e[0m"
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
echo tcp.gnmap >> gnmap
echo udp.gnmap >> gnmap

# Creates files for open ports
echo -e "\e[1;33mParsing Open Ports\e[0m"
/opt/nmap-grep.sh ./gnmap

# Creating File structure
mkdir service-scans
mkdir logs
mkdir logs/domain-info-users
mkdir logs/shares
mkdir scanner-screens
mkdir kali-screens
mkdir web-screens
mkdir reporting
mkdir reporting/anon-share
mkdir reporting/ntlm-relay
mkdir reporting/snmp-strings

# Check for Anonymous Shares
cme smb ports/445 -u '' -p '' --shares | tee logs/shares/cme_anon.log
smbmap -u '' -p '' --host-file service-scans/smb-hostst.txt | tee logs/shares/smbmap-anonymous.log
smbmap -u 'Guest' -p '' --host-file service-scans/smb-hosts.txt | tee logs/shares/smbmap-guest.log
for i in $(cat service-scans/ftp-hosts.txt); do echo $i; curl ftp://$i/ --max-time 30; echo ""; done | tee logs/shares/curl-ftp-scan.log

# Check for Anonymous Domain Enumeration
echo -e "\e[1;33mTesting Anonomous Domain Enumeration\e[0m"
for i in $(cat ldaps-hosts.txt); do rpcclient -U "" -N -c enumdomusers $i > logs/rpcclient-anon-users$i.log ; done
for i in $(cat ldaps-hosts.txt); do enum4linux -G -U $i > logs/enum4linux-anon-$i.log ; done

# Web Vuln Scans #
nikto -ssl -port 443 -host https-hosts.txt -Format html -output final_nikto_https -Tuning 0,5,8,a
nikto  -host http-hosts.txt -Format html -output final_nikto_http -Tuning 0,5,8,a

# EyeWitness or Aquatone for Web Applications
echo -e "\e[1;33mRunning Aquatone\e[0m"
#/opt/EyeWitness/EyeWitness.py -f urls --web --no-prompt
cat service-scans/web-urls.txt | /opt/aquatone -out /$client/web-screens/

# Run Metasploit Modules based on MSFenum.rc
## echo -e "\e[1;33mRunning Metasploit\e[0m"
## msfconsole -r /pathtometasploit.rc
