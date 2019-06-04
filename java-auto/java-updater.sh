#!/bin/bash


#
# DESCRIPTION:
# This script is intended to automatically 
# upgrade JRE on predefined Windows client machines.
# 
# REQUIREMENTS:
#  Server:
# 	- installed pkgs -- wget, rsync, wakeonlan, ssmtp, pssh 
# 
# Target/Client PCs:
# 	- cygwin env + ssh, rsync pkgs
# 
# Common:
# - auto ssh login from server to clients
# - account that have admin rights on target machines, I've used root.
# - You need to create & fill in hosts file in script's dir with target hostnames/IPs.
# - ...same with macs.wol file but with MAC addresses only.
#  
# AUTHOR:					
# 03/2019, Valentin Georgiev <dev@vgeorgiev.net> 
#

# set correct CWD
 cd "$(dirname "$0")"

# check if hosts file exist and is not empty
 [ -s hosts ] || $(echo "hosts file is missing or empty!" ; exit 1)

# get Java download page for further processing
 wget -q -N https://www.java.com/en/download/manual.jsp -O manual.jsp

# create it if missing
 [ -f prev_jre_ver.txt ] || touch prev_jre_ver.txt

# define vars
 prev_jre_ver=$(cat prev_jre_ver.txt)
 current_jre_ver=$(grep -m 1 Recommended manual.jsp | cut -d" " -f4- | awk -F "<" '{print $1}' |sed -e 's/ /-/g')
 download_link=$(grep -m 1 "Windows Offline" manual.jsp | grep https | awk -F 'href="' '{print $2}' | awk -F '"' '{print $1}')
 jre_file_name=jre_current_ver.exe

if [ "$prev_jre_ver" != "$current_jre_ver" ]; then

	# if wakeonlan pkg is installed, wakeup target sleepy pcs
	 if [ -f /usr/bin/wakeonlan ] ; then 
		/usr/bin/wakeonlan -f macs.wol
 	 fi

	# download updated jre file
         wget $download_link -O $jre_file_name

	# transfer jre file to hosts locally
	 for i in $(cat hosts)
	 do 
		rsync -av --timeout=15 $jre_file_name root@$i:/cygdrive/c/ 
	 done
	
	# add execution bits on jre file and proceed with installation
	 pssh -i -t 180 -l root -h hosts "chmod +x /cygdrive/c/$jre_file_name ; cd /cygdrive/c/ ; ./$jre_file_name /s REMOVEOUTOFDATEJRES=1"

	# generate post install stats file	
	 pssh -i -t 180 -l root -h hosts "wmic product get name | grep.exe Java |grep -v Updater" > installation.stats 2>&1
	

# DO NOT indent EOL header! (ssmtp header info)

cat > summary.txt <<EOL
To:<DESTINATION-EMAIL>
From:<SENDER-EMAIL>
Subject: Java auto upgrade results

Current JRE version is $current_jre_ver	

Installation statistics:		

EOL
	# add install stats
	 cat installation.stats				>> summary.txt
	
	# Send summary information
	 /usr/sbin/ssmtp <DESTINATION-EMAIL>	         < summary.txt

	# update prev_jre_ver.txt file with last version
 	 echo "$current_jre_ver" > prev_jre_ver.txt

fi
# End-of-file
