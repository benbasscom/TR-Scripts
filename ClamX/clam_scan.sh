#!/bin/bash
# Created by Ben Bass
# Copyright 2012 Technology Revealed. All rights reserved.
# ClamScan run for YCMS1.com
vers="clam_scan-0.3"

# Set log files for stdout & stderror
log="/Library/Logs/com.trmacs/clam/scan-log.log"
err_log="/Library/Logs/com.trmacs/clam/scan-error.log"

# exec 1 captures stdtout and exec 2 captures stderr and we are appending to log files.
exec 1>> "${log}"
exec 2>> "${err_log}"
host_name="$(scutil --get HostName)"
when="$(date)"

echo ""$vers" Scanning "$host_name" with Clam on "$when""
echo "running /usr/local/clamXav/bin/clamscan -ri --move=/clamquarantine --detect-pua=yes --include-pua=Spy --include-pua=Script --exclude-dir=^/sys\|^/proc\|^/clamquarantine\|^/Volumes\  / | tee -a /clamlogs/scanlog.log"

/usr/local/clamXav/bin/clamscan -ri --move=/clamquarantine --detect-pua=yes --include-pua=Spy --include-pua=Script --exclude-dir=^/sys\|^/proc\|^/clamquarantine\^/Volumes\  / | tee -a /clamlogs/scanlog.log

echo "-------------------------------------------"
exit 0