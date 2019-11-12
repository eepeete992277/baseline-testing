# baseline-testing
## Scripts and Tools to Assist With 'all the things'

This page will serve as both a wiki/reference and script repo for all the things n' stuff.


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






