#!/bin/bash
#checks to see if home.benbass.com resolves to 10.0.240.10.  If not, skip running time machine.

home_check="10.0.240.10"
subchck="$(nslookup home.benbass.com | grep 'Address' | tail -1 | cut -d : -f2 | awk '{print $1}')"
time="$(date +%H)"

if [[ $time -lt 7 ]] || [[ $time -gt 17 ]]; then

	if [[ $subchck == $home_check ]]; then
		echo "On local network - and not between 7 and 5 - Running Time Machine..."
		tmutil startbackup --auto
	else
		echo "NOT on local network - Skipping Time Machine..."
	fi
	else
	echo "Skipping between 7am and 5pm "

fi
	exit 0