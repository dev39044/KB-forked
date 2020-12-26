"""This module is a backup solution based on rsync."""

import glob
import os
import subprocess
import time

from common.notify import notify

"""
define rsync args
start rsync transfer
    you need target-host, src, dest dirs
adding sync info to log files
cut needful info
add error info to summary file
send email
"""


class Backup:
    def __init__(self, host, fail_cnt=7, port=22):
        self.date = time.strftime('%d_%m_%Y_%H:%M:%S')
        self.day = time.strftime('%d')
        self.dst_dir = '/BACKUP/' + self.host
        self.fail_cnt = fail_cnt
        self.file = 'fail_cnt'
        self.host = host
        self.log_file = 'data_' + self.day + '_' + self.host + '.log'
        self.err_file = 'data_' + self.day + '_' + self.host + '.err'
        self.old_files = 'old_files'
        self.port = port

        if not os.path.exists(self.dst_dir):
            os.makedirs(self.dst_dir)
        if not os.path.exists(self.old_files):
            os.makedirs(self.old_files)

        self.cleanup()
        self.host_check()

    def failed(self, errs=None):
        """Check how many bkp attempts failed."""
        num = int(open(self.file).read())
        with open(self.file, 'w') as f:
            if num == self.fail_cnt:
                f.write('0')
                notify(subject=f'{self.fail_cnt} backups failed for {self.host}!', body=errs)
            else:
                num += 1
                f.write(str(num))

    def cleanup(self):
        """Clean up old data logs."""
        for f in glob.glob('data_*.*'):
            os.replace(f, self.old_files + '/' + f)

    def host_check(self):
        try:
            subprocess.run(['ssh', '-o', 'ConnectTimeout=7', '-p', self.port, self.host])
        except ConnectionError as e:
            self.failed(errs=e)

    def mount_check(self, mount=None):
        if mount:
            try:
                subprocess.run(['ssh', '-o', 'ConnectTimeout=7', '-p', self.port, self.host,
                                'mountpoint', mount])
            except Exception:
                self.failed(errs=f"{mount} is not a mountpoint!")

    def sync(self, opts=''):
        try:
            # subprocess.run(['rsync', '-avh', opts, '-stats', '-progress', '-e="ssh -p'
            # TODO : FIX

    def log(self):
        pass
