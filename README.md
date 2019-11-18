***granularity on these things and stuff. join me and put them all inside a box***  
##############  
##############

WORK IN PROGRESS 
======

This Repo is to help people do things related to internals.

### small/temp devices
- [/opt/](http://www.pathname.com/fhs/pub/fhs-2.3.html#OPTADDONAPPLICATIONSOFTWAREPACKAGES)
```bash
git https://github.com/eepeete992277/baseline-testing ~/
cp /baseline-testing/
```

### Scripts Overview ###  

/mobile-unit/
======
**autoMITM6.sh**
-starts MITM6 and responder via tmux split windows  

**canc-inst.sh**  
-installs and configures impacket, proxychains, python-pip, responder, mitm6, impacket, covenant, and dotnet core

**cowboyrecon.sh**   
-responder-runfinger scan . We are trying to identify hosts which are vulnerable to MS17, SMB Signing State, Null Session Presence

**sockparse.sh**   
-pipe or copy form ntlmrelayx socks list to parse list into files that can be piped into for loops for registry dump and share Enumeration  
-quick check for service accounts in secretsdump, if true, the scripts starts svcChk.sh

**svcChk.sh**  
-Simply takes the parsed SVC accounts and attempts to log into the computer via SMB to verify validity of SVC accounts

**commands.txt**
-commands used to loop through smbclient.py with svcChk.sh ( eventually going to just echo these commands into commands.txt to start )
  
/reporting/
======
**report.sh**  
-cat's directory contents to a text file, loops through that file and takes a screenshot of the window and saves to outpu
-attempts to identify affected entities for common attacks (work in progress)  


/MSF Scripts/
======
msf-anon-rce.rc  
msf-appendix.rc  
msf-Maleick.rc  
msf-pw-attck.rc  
msf-web.rc  


# These scripts use the following repositories
- [Impacket](https://github.com/https://github.com/SecureAuthCorp/impacket)
- [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec)
- [EyeWitness](https://github.com/FortyNorthSecurity/EyeWitness)
- [Covenant](https://github.com/cobbr/Covenant)
- [Responder](https://github.com/lgandx/Responder)
- [mitm6](https://github.com/fox-it/mitm6)
- [DotNet Core (2.2)](https://dotnet.microsoft.com/download/dotnet-core/2.2)


# TODO




in progress.
```bash
example usage
```




