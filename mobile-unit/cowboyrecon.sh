#!/usr/bin/bash
#
# scanner-recon script
#
# scanner-recon.sh Version: .00
# Author: Evan Royer
# Date: 11/11/19

# Help Text

echo -e "\e[1;33m\e[0m"
echo -e "\e[1;33mPrepping data && checking dependencies\e[0m"
echo -e "\e[1;33m--------------------------------------\e[0m"

for i in $(cat subnets); do responder-RunFinger -g -i $i ; >> runfinger.log; done
grep "Signing:'False'" runfinger.log | awk -F, '{print $1}' | tr -d "'" | tr -d "[" | sort -t. -n -k1,1 -k2,2 -k3,3 -k4,4 | tee signing.disabled.log
echo -e "\e[1;33mSMB Signing Disabled:\e[0m"
sleep 2
cat runfinger.log | awk -F, '{print $1, $4 , $2, $3}' | tr -d "'" | tr -d "[" | sort -t. -n -k1,1 -k2,2 -k3,3 -k4,4 | grep "Signing:False" | tee signing.disabled.log

echo ""
echo -e "\e[1;33mVulnerable to MS17:\e[0m"
cat runfinger.log | awk -F, '{print $1, $7 , $2, $3}' | tr -d "'" | tr -d "[" | tr -d "]" | sort -t. -n -k1,1 -k2,2 -k3,3 -k4,4 | grep "MS17-010: True" | tee ms17.log
sleep 2
