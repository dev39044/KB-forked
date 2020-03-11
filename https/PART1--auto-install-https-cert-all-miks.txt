#!/bin/bash
#
# DESCRIPTION:
# This script is intended to automatically install valid https 
# certificate + key pair on all predefined mikrotik RBs.
#
# REQUIREMENTS:
# 1. Mikrotik user with limited perms & auto ssh login enabled. 
# 2. host target list/array
# 3. Certificate + key pair
#
# AUTHOR:                                       
# Valentin Georgiev <dev@vgeorgiev.net> 
# v0.1, created 02/2020
# ==============================================

# Enter CWD                                                                                                                                                                                                   
cd "$(dirname "$0")"

# Log script's output
#set -xv
#exec 1>log.out 2>&1

# ----------------- VARS ------------------
# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # no color

# certs
CERT=cert.pem
KEY=key.pem
ACTION=cert-actions.rsc

# domain
DN=

# login user
USER=

# ports
PORT1=
PORT2=
WEBPORT1=
WEBPORT2=

# Define host list
host_list=(YOUR HOSTNAMES HERE, e.g host1 host2 host3 etc...)
# ------------------------------------------

# Check if certicate pair exist and we can access them
if ! [[ -r $CERT && -r $KEY ]] ; then
        printf "$RED[ERROR]$NC Missing files or lack of perms! Abort ...\n" 
        exit 1
fi

# copy files to all miks, then test.
for i in "${host_list[@]}"
do 
        scp -P $PORT1 $CERT $KEY $ACTION $USER@$i:/ >> log.out 2>&1
        ssh -p $PORT1 $USER@$i /import $ACTION >> log.out 2>&1
        # Test if installed certs are valid.
        /usr/bin/timeout 4 openssl s_client -showcerts -connect $i.$DN:$WEBPORT1 </dev/null >/dev/null 2>&1
        if [[ $? -ne 0 ]] ; then 
                printf "$RED[ERROR] Cert installation of $i failed!\n"
        else 
        # test when certs expire.
                printf "Expiration date:\t $(echo | openssl s_client -connect $i.$DN:$WEBPORT1 2>/dev/null | openssl x509 -noout -dates |grep After |cut -d= -f2) \
        Cert install $GREEN[OK]$NC of $i\n" 
        fi
done

# mikX is at the same IP address but ssh port X, 
# thus define it separately.
i=mikX
scp -P $PORT2 $CERT $KEY $ACTION $USER@$i:/ >> log.out 2>&1
ssh -p $PORT2 $USER@$i /import $ACTION >> log.out 2>&1
# Test if installed certs are valid.
/usr/bin/timeout 4 openssl s_client -showcerts -connect $i.$DN:$WEBPORT2 </dev/null >/dev/null 2>&1
if [[ $? -ne 0 ]] ; then
        echo "$RED[ERROR]$NC Cert installation of $i failed!\n"
else
# test when certs expire.
        printf "Expiration date:\t $(echo | openssl s_client -connect $i.$DN:$WEBPORT2 2>/dev/null | openssl x509 -noout -dates |grep After |cut -d= -f2) \
        Cert install $GREEN[OK]$NC of $i\n"
fi

# EOF
