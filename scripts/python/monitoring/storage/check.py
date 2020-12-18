#!/usr/bin/env python3
'''
Description: Monitor health status of local mdraids
Requrements: mdadm
Author: Valentin Georgiev dev@vgeorgiev.net 
Date: 12/2020
'''

import os
import re
import subprocess
import socket
from common.notify import notify

# Enter script's working directory
os.chdir(os.path.dirname(__file__))

host = socket.gethostname()


def health_check(raid, num):
    fail = 'FAIL' + str(num)
    if not re.search('clean|active|resync', str(stat)):
        if not os.path.exists(fail): 
            os.mknod(fail)
            notify(raid + ' is not clean on ' + host + '!')
    else:
        if os.path.isfile(fail):
            os.remove(fail)
            notify(raid + ' is now OK on ' + host + '.')


# check local mdraids
for num in range(3):
    raid = '/dev/md' + str(num)
    if os.path.exists(raid):
        stat = subprocess.run('mdadm -D ' + raid + '|grep "State :"', shell=True, capture_output=True, text=True)
        health_check(raid, num)
    else:
        notify(raid + ' is not a valid device on ' + host)

