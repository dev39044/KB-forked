#!/bin/bash
#
# DESCRIPTION:
# This script is intended to automatically sync Mikrotik boards.
# Granted permissions for this ssh user are:
# policy=ssh,ftp,read,sensitive,write 
#
# REQUIREMENTS:
# 1. Mikrotik user with limited perms & auto ssh login enabled. 
# 2. Enough perms to execute required commands
#
# AUTHOR:                                       
# 06/2019, Valentin Georgiev <dev@vgeorgiev.net> 
# ------------------------------------------------

# Enter CWD
cd "$(dirname "$0")"

# some vars
src_rb=IP
dst_rb=IP

# Add email notification data
cat > summary.txt <<EOL
To: <EMAIL>
From: <EMAIL>
Subject: Mik Sync failed
EOL

# Check if RBs are accessible || exit
for i in "$src_rb" "$dst_rb"
do 
	ping $i -c 5 -W 10
	if  [ $? -ne 0 ] ; then
		echo "RB $i is not accessible!" >> summary.txt
		echo "Script aborted!" >> summary.txt
		/usr/sbin/ssmtp <EMAIL> < summary.txt	
		exit
	fi
done

# Add commands for removal of destination RB's current data
echo '
/ip firewall filter remove [/ip firewall filter find]
/ip firewall address-list remove [/ip firewall address-list find]
/ip firewall nat remove [/ip firewall nat find]
/ip firewall layer7-protocol remove [/ip firewall layer7-protocol find]
/ip pool remove [/ip pool find]
/ip dhcp-server lease remove [/ip dhcp-server lease find]
' > src_rb.rsc 

# # # IMPORTANT !!! 
# # # ORDER OF EXECUTING BELOW COMMANDS IS IMPORTANT !!!
# # # IMPORTANT !!! 

# Define array of commands to execute on destination RB
cmds[0]='/ip firewall address-list export'
cmds[1]='/ip firewall layer7-protocol export'
cmds[2]='/ip firewall filter export'
cmds[3]='/ip firewall nat export'
cmds[4]='/ip pool export'
cmds[5]='/ip dhcp-server lease export'

for i in "${cmds[@]}" ; do ssh -p 30017 kobila@"$src_rb" $i ; done >> src_rb.rsc

# Upload config rsc file on destination RB
scp -P 30017 src_rb.rsc kobila@"$dst_rb":/

# Execute rsc file
ssh -p 30017 kobila@"$dst_rb" /import src_rb.rsc
