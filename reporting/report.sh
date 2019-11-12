# Loops through log folder and takes screenshots of window #
# Must have kali box open for gnome-screenshot to work, unfortunately this will not work over SSH #
# Run in logs folder #
#!/usr/bin/env bash
mkdir screens
mkdir screens/recon
mkdir screens/appendix
scp ~ user@x.x.x.x:~/logs/* ./

if [ $(dpkg-query -W -f='${Status}' gnome-screenshot 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt install gnome-screenshot -y;
fi

ls * >> filelist.txt
for i in $(cat filelist.txt); do grep [+] $i && gnome-screenshot -wB --file=screens/$i.png && clear; done

#report structure #
echo -e "\e[1;33m Affected Entities:\e[0m"

#snmp_default_strings
echo "snmp default community strings"
grep [+] snmp_login.log | awk '{print $2}' | uniq | tee report/snmp-strings.

# Scanner logs, screenshots, evidence #
ls * >> filelist.txt
mkdir scanner-screens
~/Responder/Report.py | tee ./responder-report.log
for i in $(cat filelist.txt); do cat $i && gnome-screenshot -wB --file=scanner-screens/$i.png && clear; done
#tee ntlmrelayx output logs
#run ~/traceadmin/Responder/report.py | tee ~/traceadmin/logs/responder_report.log
#
