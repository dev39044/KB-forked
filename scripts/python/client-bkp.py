#!/usr/bin/env python3

import os
from common.backup import Backup
from common.flocker import FLocker
from common.notify import notify

# Enter script's working directory
os.chdir(os.path.dirname(__file__))

# Set script locking
lock = FLocker(os.path.basename(__file__))

# Define some vars
host = 'user-pc'
pref = 'root@' + host + ':'
src_dir1 = pref + '/cygdrive/c/Users/User'

# Create backup object
b = Backup(host)
b.sync_to_kobila(src_dir1)
