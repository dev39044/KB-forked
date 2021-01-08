"""This module is a backup solution based on rsync."""

import glob
import os
import subprocess
<<<<<<< HEAD
import sys
=======
>>>>>>> 4cf653ba35a9b703e6493cf74c20714d5eca843a
import time

from common.notify import notify

<<<<<<< HEAD

class Backup:
    """Define vars and make initial preparation."""
    def __init__(self, host, fail_cnt='7', port='22'):
        self.date = time.strftime('%d_%m_%Y_%H:%M:%S')
        self.day = time.strftime('%d')
        self.fail_cnt = fail_cnt
        self.file = 'fail_cnt'
        self.host = host
        self.current = '/BACKUP/' + self.host + '/current'
        self.dst_dir = '/BACKUP/' + self.host + '/links/' + self.date
=======
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
>>>>>>> 4cf653ba35a9b703e6493cf74c20714d5eca843a
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

<<<<<<< HEAD
    def fail_reset(self):
        """Reset fail bkp attempts file counter."""
        with open(self.file, 'w') as f:
            f.write('0')

    def failed(self, errs=''):
        """Check if max fail bkp attempts is reached."""
        if not os.path.exists(self.file):
            os.mknod(self.file)
            self.fail_reset()
        num = open(self.file).read()
=======
    def failed(self, errs=None):
        """Check how many bkp attempts failed."""
        num = int(open(self.file).read())
>>>>>>> 4cf653ba35a9b703e6493cf74c20714d5eca843a
        with open(self.file, 'w') as f:
            if num == self.fail_cnt:
                f.write('0')
                notify(subject=f'{self.fail_cnt} backups failed for {self.host}!', body=errs)
            else:
<<<<<<< HEAD
                num = int(num) + 1
=======
                num += 1
>>>>>>> 4cf653ba35a9b703e6493cf74c20714d5eca843a
                f.write(str(num))

    def cleanup(self):
        """Clean up old data logs."""
        for f in glob.glob('data_*.*'):
            os.replace(f, self.old_files + '/' + f)

    def host_check(self):
<<<<<<< HEAD
        """Make sure host is alive."""
        try:
            subprocess.run(['nc', '-zw', '7', self.host, self.port],
                           text=True, capture_output=True, check=True)
        except Exception as e:
            self.failed(errs=str(e))
            sys.exit(1)

    def mount_check(self, mount=None):
        """Check if destination target folder is mounted."""
=======
        try:
            subprocess.run(['ssh', '-o', 'ConnectTimeout=7', '-p', self.port, self.host])
        except ConnectionError as e:
            self.failed(errs=e)

    def mount_check(self, mount=None):
>>>>>>> 4cf653ba35a9b703e6493cf74c20714d5eca843a
        if mount:
            try:
                subprocess.run(['ssh', '-o', 'ConnectTimeout=7', '-p', self.port, self.host,
                                'mountpoint', mount])
            except Exception:
                self.failed(errs=f"{mount} is not a mountpoint!")

<<<<<<< HEAD
    def sync_to_kobila(self, *src_dirs, opts=''):
        """Sync data from clients to backup server."""
        # we make src_dirs as a str, instead of a tuple.
        src_dirs = ' '.join(src_dirs)
        cmd = f'time --verbose -a -o {self.log_file} rsync -rlptvhz{opts} ' \
              f'--stats --progress --exclude-from=exclude --link-dest={self.current} ' \
              f'-e "ssh -p {self.port}" {src_dirs} {self.dst_dir}'
        try:
            with open(self.log_file, 'w') as l, open(self.err_file, 'w') as e:
                subprocess.run(cmd, shell=True, stdout=l, stderr=e)
                self.set_pointer()
                self.parse_logs()
        except Exception as e:
            print(e, 'sync_to_kobila func exception')
            notify(subject=f'{self.host} backup failed!', body=e)

    def set_pointer(self):
        """Set hard link pointer."""
        if os.path.exists(self.current):
            os.remove(self.current)
        try:
            subprocess.run(['ln', '-sr', self.dst_dir, self.current])
        except Exception as e:
            print(e, 'set_pointer func exception')
            notify(subject=f'{self.host} backup issues with set_pointer!', body=e)

    def parse_logs(self):
        """Parse log files and report errors."""
        if os.stat(self.err_file).st_size != 0:
            notify(subject=f'{self.host} backup parse_logs issues!', attachment=self.err_file)
        else:
            self.fail_reset()
=======
    def sync(self, opts=''):
        try:
            # subprocess.run(['rsync', '-avh', opts, '-stats', '-progress', '-e="ssh -p'
            # TODO : FIX

    def log(self):
        pass
>>>>>>> 4cf653ba35a9b703e6493cf74c20714d5eca843a
