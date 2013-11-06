#!/bin/bash
# Created by Ben Bass
# Copyright 2012 Technology Revealed. All rights reserved.
# ClamScan run for YCMS1.com
vers="fresh_clam-0.1"

# Set log files for stdout & stderror
log="/Library/Logs/com.trmacs/clam/fresh-log.log"
err_log="/Library/Logs/com.trmacs/clam/fresh-error.log"

# exec 1 captures stdtout and exec 2 captures stderr and we are appending to log files.
exec 1>> "${log}"
exec 2>> "${err_log}"
host_name="$(scutil --get HostName)"

echo ""$vers" updating clam definitions on "$host_name" on "$date""
/usr/local/clamXav/bin/freshclam
echo "-------------------------------------------"
exit 0