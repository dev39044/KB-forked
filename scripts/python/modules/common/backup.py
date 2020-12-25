"""This module implements a backup solution."""

import glob
import os
import time
from common.notify import notify

__author__ = "Valentin Georgiev"
__email__ = "dev@vgeorgiev.net"

# OK -- cd cwd - This one for sure must be set in client script.
# lock file -- test if locking should be a method or something else...

# OK -- define date var
# OK -- move old files
# check if host is alive
    # allow X nums of failed attempts
# check if remote mountpoint is there(magare)
#     if not send alarm
# define rsync args
# start rsync transfer
#     you need target-host, src, dest dirs
# adding sync info to log files
# cut needful info
# add error info to summary file
# send email

class Backup:
    def __init__(self, host):
        self.date = time.strftime('%d_%m_%Y_%H:%M:%S')
        self.day = time.strftime('%d')
        self.dst_dir = '/BACKUP/' + host
        self.log_file = 'data_' + self.day + '_' + host + '.log'
        self.err_file = 'data_' + self.day + '_' + host + '.err'
        self.old_files = 'old_files'

        if not os.path.exists(self.dst_dir):
            os.makedirs(self.dst_dir)
        if not os.path.exists(self.old_files):
            os.makedirs(self.old_files)

    def cleanup(self):
        """Move old data logs."""
        for f in glob.glob('data_*.*'):
            os.replace(f, self.old_files + '/' + f)

    def host_check(self):
        pass

    def mount_check(self):
        pass

    def fail_bkp(self):
        pass

    def sync(self):
        pass

    def log(self):
        pass
