# baseline-testing
## Scripts | Tools | Techniques to Assist With 'all the things'

This page will serve as both a wiki/reference and script repo for all the things n' stuff.

## To Do:
-decide on naming conventions
-add wiki subpages for all baseline testing inclusions
-deploy report writing platform (roadmap-completion: 11/15/19)
-consider pushing this data into csv's and then django modules
-additions to ipt script
        -username enumeration
                -kerbrute preauth (low detection, no lockout)
                -snmp
                -RID cycling
                -External sources (harvester, discover, linkedIn scraping, etc)

# Methodology | Order of Operations ##
##Start NMAP/Initial Recon Scan:
(Self Explanatory)

## Start relay attack:
1. Configure Responder.conf
2. Configure /etc/proxychains.conf
3. Enumerate SMB Signing Disabled Hosts
4. Start mitm6
5. Start Responder
6. Start ntlmrelayx
7. Continue to run until sockets build up then save sockets to file (socketslist).
        baseline-testing/mobile-unit/svcChk.sh 






