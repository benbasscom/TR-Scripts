#!/bin/bash
# Apple Hardware RAID check
vers="applehwraidcheck-1.3"
# Created by Ben Bass
# Copyright 2012 Technology Revealed. All rights reserved.
# This script checks the internal Apple Software Raid to see if it is degraded.
# It logs this to a file and if degraded sends an e-mail.
# This works with an xserve with 3 Drives - not tested in other devices.
# 1.3 added vers variable.

to="ben@trmacs.com"
log="/Library/Logs/com.trmacs/applehwraidcheck.log"
err_log="/Library/Logs/com.trmacs/applehwraidcheck-err.log"

exec 1>> "${log}" 
exec 2>> "${err_log}"

hw_raid_status="$(system_profiler SPHardwareRAIDDataType | grep Status: | tail -2 | head -1 | awk '{print $2" "$3}')"
raid_good="Viable (Good)"
when="$(date +%m/%d/%Y%n%H:%M)"
hw_raid_name="$(system_profiler SPHardwareRAIDDataType | grep Volumes: | head -1 | awk '{print $2}')"

# Set the host name for easy identification.
host_raw="$(scutil --get HostName)"

if [ -z "$host_raw" ]; then
	host_name="$(scutil --get ComputerName)"
else	
	host_name="$host_raw"
fi

#---------------------------------------------------------------------------------------------

if [ "$hw_raid_status" != "$raid_good" ]; then

	echo "At "$when" the Apple Hardware RAID "$hw_raid_name" on "$host_name" is currently "$hw_raid_status"." \
    | mail -s ""$host_name" Apple Hardware Raid Failure Notice" "$to"; \
 echo "At "$when" the Apple Hardware RAID "$hw_raid_name" on "$host_name" is currently "$hw_raid_status".  \
     An e-mail notification has been sent to "$to"."

else
	echo "At "$when" the Apple Hardware RAID "$hw_raid_name" on "$host_name" is currently "$hw_raid_status"."
fi

exit 0