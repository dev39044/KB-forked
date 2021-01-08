"""Module for file locking mechanism."""

import atexit
import fcntl
import os
import signal
import sys

__author__ = "Valentin Georgiev"
__email__ = "dev@vgeorgiev.net"

class FLocker:
    def __init__(self, file_name):
        self.file_name = file_name
        self.file = '/run/lock/' + self.file_name + '.lock'

        # clean up catchers
        signal.signal(signal.SIGTERM, self.release)
        signal.signal(signal.SIGINT, self.release)
        atexit.register(self.release)

        # set lock
        try:
            if not os.path.exists(self.file):
                os.mknod(self.file)
            self.f = open(self.file)
            fcntl.flock(self.f, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError as e:
            sys.exit(1)

    def release(self, signum=None, frame=None):
        try:
            fcntl.flock(self.f, fcntl.LOCK_UN)
            os.remove(self.file)
            sys.exit(1)
        except OSError as e:
            sys.exit(1)
