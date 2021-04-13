#!/bin/bash
#
# DESCRIPTION:
# This script fixes Cron (Vixie) and replaces some headers
# most notably From and X-*
# Cron hardcodes From header to:

# From: root (Cron Daemon)
# To: sender@domain.com --- this is defined by MAILTO in crontab
# Subject: Cron <root@kobila> echo "test" 
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# X-Cron-Env: <MAILTO=sender@domain.com>
# X-Cron-Env: <PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin>
# X-Cron-Env: <SHELL=/bin/sh>
# X-Cron-Env: <HOME=/root>
# X-Cron-Env: <LOGNAME=root> 

# So that the above headers, result in "Spoofed sender email address" ... and sending fails.
# We replace From and remove X-* headers 
#  
# AUTHOR:                                       
# 03/2021, Valentin Georgiev <dev@vgeorgiev.net> 
# ==============================================

sed 's/^From.*/From: sender@domain.com/g' | sed '/^X-Cron/d' | msmtp sender@domain.com
