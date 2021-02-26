#!/bin/bash
#
# This script is intended to send some random files by email to specific users,
# so that integrity and completeness of mentioned files to be verified.

cd "$(dirname "$0")"
export IFS=$'\n'

# Log script's output 
set -xv
exec 1> log.out 2>&1

# define some vars
pref='/BACKUP/xxxxsrv/current/FILES/xxxxDATA/'
user1='xxxx@xxxx.bg'
user2='xxxx@xxxx.bg'
user3='xxxx@xxxx.bg'

# clean up status file & files folder
rm -f files/*

# get 3 dwg files and by 1 of pdf, xls(x), doc(x) exts, make them lowercase,
# replace spaces with _ and delete unneeded files. Skip ~* files.
files() {
 find $pref -type f -mtime -10 \( -iname "*.$1" ! -iname "~*" \) -exec cp -av {} files/ \;
 rename 'y/A-Z/a-z/' files/*.*
 rename 's/ /_/g' files/*.*
 for i in `ls -1 files/*.$1 | tail -n +$2` ; do rm -fv $i ; done
}


# attach and email sorted files.
# ${@:2} is cool bash feature that catches all but first parameters.
send() {
 mutt -s "This is subject." ${@:2} -- $1 < email-templ.txt
}


# --------- $user1 --------------
for i in pdf xls* doc* ; do files $i 2 ; done

# --------- $user2 --------------
for i in dwg ; do files $i 4 ; done

send $user1,$user2 -a files/*.pdf -a files/*.xls* -a files/*.doc*
send $user3 -a files/*.dwg

# End-of-file
