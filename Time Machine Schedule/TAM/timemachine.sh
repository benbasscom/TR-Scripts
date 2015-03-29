#!/bin/bash
# Automatic Time Machine script
vers="timemachine-1.6.0_TAM"
# Created by Ben Bass
# Copyright 2013 Technology Revealed. All rights reserved.
# Time machine runs at noon, before 9 AM and after 6 PM.

log="/Library/Logs/com.trmacs/timemachine.log"
err_log="/Library/Logs/com.trmacs/timemachine-err.log"
exec 1>> "${log}" 
exec 2>> "${err_log}"

when=$(date '+%m/%d/%Y %H:%M')

os_chck="$(system_profiler SPSoftwareDataType | grep "System Version:" | cut -d : -f2 | sed 's/ //')"
os_vers_chck="$(echo "$os_chck" | sed 's/[MacOSXerv .]//g' | cut -f1 -d\( | cut -c 1-3)"
time="$(date +%H)"

if [ "$time" -ge "08" -a "$time" -le "18" ]
	then
	echo "at $when, it is between 9 am to 6 PM and not noon.  Skipping Time Machine."
exit 0
fi


if [[ "$os_vers_chck" -le 106 ]]; then
		echo "At $when we are on the local network Running Time Machine..."
		/System/Library/CoreServices/backupd.bundle/Contents/Resources/backupd-helper
			exit 0
			else
		echo "Running Lion or higher."
fi	

if [[ "$os_vers_chck" -ge 107 ]]; then
		echo "At $when we are on the local network Running Time Machine..."
			tmutil startbackup --auto
			exit 0
	else
		echo "Not running SL."
fi	

exit 0