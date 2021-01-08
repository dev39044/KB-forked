#!/usr/bin/env python3
"""Monitor if webpage is alive."""


import os
import re
import subprocess
from common.notify import notify

# Enter script's working directory
os.chdir(os.path.dirname(__file__))

# define some vars
fail = os.path.isfile('FAIL')
ok = 'Web is OK'
down = 'Web is DOWN'
web = 'https://webpage.com:PORT/subpage.html'
keyword = 'your-re.search-keyword'

# Check if the initial MonetaWeb App page is accessible
data = subprocess.run(['curl', web], capture_output=True, text=True)

# check if login page is there
if re.search(keyword, str(data)):
    if fail:
        os.remove('FAIL')
        notify(ok)
else:
    if not fail:
        os.mknod('FAIL')
        notify(down)
