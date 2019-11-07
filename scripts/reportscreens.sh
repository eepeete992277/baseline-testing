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


# Scanner logs, screenshots, evidence #
#tee ntlmrelayx output logs
#run ~/traceadmin/Responder/report.py | tee ~/traceadmin/logs/responder_report.log
#
