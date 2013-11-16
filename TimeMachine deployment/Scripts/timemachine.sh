#!/bin/bash

home_check="server's IP"
subchck="$(nslookup serversFQDN | grep 'Address' | tail -1 | cut -d : -f2 | awk '{print $1}')"

if [[ $subchck == $home_check ]]
then
	echo "On local network - Running Time Machine..."
	/System/Library/CoreServices/backupd.bundle/Contents/Resources/backupd-helper
else
	echo "NOT on local network - Skipping Time Machine..."
fi

exit 0