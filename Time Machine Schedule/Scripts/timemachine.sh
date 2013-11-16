#!/bin/bash
#checks to see if home.benbass.com resolves to 10.0.240.10.  If not, skip running time machine.

log="/Library/Logs/com.trmacs/timemachine.log"
err_log="/Library/Logs/com.trmacs/timemachine-err.log"
exec 1>> "${log}" 
exec 2>> "${err_log}"

when=$(date '+%m/%d/%Y %H:%M')

home_check="10.0.240.10"
subchck="$(nslookup home.benbass.com | grep 'Address' | tail -1 | cut -d : -f2 | awk '{print $1}')"
time="$(date +%H)"

if [[ $time -lt 7 ]] || [[ $time -gt 17 ]]; then

	if [[ $subchck == $home_check ]]; then
		echo "At $when we are on the local network - and it is not between 7am and 5pm - Running Time Machine..."
		tmutil startbackup --auto
	else
		echo "at $when we are NOT on local network - Skipping Time Machine..."
	fi
	else
	echo "at $when it we are skipping time machine since it is between 7am and 5pm "

fi
	exit 0