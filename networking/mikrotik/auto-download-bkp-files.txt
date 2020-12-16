#!/bin/bash
#
# DESCRIPTION:
# This script is intended to automatically download binary 
# and text backups on predefined list of Mikrotik RBs.
# After that files will be downloaded locally.

### SECURITY NOTE!
# DO NOT put rsc files on a public file server as they are clear text files
# that contain visible binary .backup restore password! You cannot hide it as
# it's parts of auto backup schedule job that is set up on Mik boards and 
# exported as part of the backup :)
#  
# Backup files are automatically created on RBs themselves
# due to security reasons as I was unable to restrict Mik user to only
# create and download backup files. Required policies were:
# policy=ssh,ftp,read,sensitive,write and this was too much permissions.
#
# REQUIREMENTS:
# 1. Mikrotik user with limited perms & auto ssh login enabled. 
# 2. host target list/array
# 3. Temp folder "bkp-files" to store downloaded files
#
# AUTHOR:                                       
# 05/2019, Valentin Georgiev <dev@vgeorgiev.net> 
# ==============================================

# Enter CWD

cd "$(dirname "$0")"

# Create bkp-files folder if missing
[[ -d bkp-files ]] || mkdir bkp-files

# Define host list/array
host_list=(host1 host2 host3 host4)

# keep diff backup versions
num=$(date +%u)

# Let's do some actual work :) 
for i in "${host_list[@]}"
do
        # Download backup files in bkp-files folder
        scp -P <PORT> USER@$i:/$i.rsc bkp-files/$i-$num.rsc
        scp -P <PORT> USER@$i:/$i.backup bkp-files/$i-$num.backup
done
