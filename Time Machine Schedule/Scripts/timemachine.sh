#!/bin/bash
# Automatic Time Machine script
vers="timemachine-1.4"
# Created by Ben Bass
# Copyright 2013 Technology Revealed. All rights reserved.
# checks to see if home.benbass.com resolves to 10.0.240.10.  If not, skip running time machine.
# does not run from 6:01 am to 8:59 am.  This is to prevent stopping a backup when leaving for work.
# 1.3 added vers variable and changed skipping from 7 am to 5 pm to skipping 6:01 am to 8:59 am.
# 1.3.1 Tweaked logging verbiage.
# 1.4 cleaned up and tested 6, 7 and 8 cut off times - doing string comparison & not integer.

log="/Library/Logs/com.trmacs/timemachine.log"
err_log="/Library/Logs/com.trmacs/timemachine-err.log"
exec 1>> "${log}" 
exec 2>> "${err_log}"

when=$(date '+%m/%d/%Y %H:%M')

home_check="10.0.240.10"
subchck="$(nslookup home.benbass.com | grep 'Address' | tail -1 | cut -d : -f2 | awk '{print $1}')"
time="$(date +%H)"

if [ "$time" == "06" -o "$time" == "07" -o "$time" == "08" ]
	then
	echo "at $when, it is between 6 am to 9 am.  Skipping Time Machine."
exit 0
fi

if [[ $subchck == $home_check ]]; then
	echo "At $when we are on the local network - and it is not between 6am and 9am - Running Time Machine..."
	tmutil startbackup --auto
else
	echo "at $when we are NOT on local network - Skipping Time Machine..."
fi
exit 0