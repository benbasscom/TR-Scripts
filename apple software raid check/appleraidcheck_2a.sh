#!/bin/bash
# Apple software RAID check
# Created by Ben Bass
vers="appleraidcheck-0.9.2-a"
# Copyright 2012 Technology Revealed. All rights reserved.
# This script checks the internal Apple Software Raid to see if it is degraded.
# It logs this to a file and if degraded sends an e-mail.
# 0.9.1 now has the version as a live variable.
# 0.9.2 Pulls the "to" variable from the address.plist.
# 0.9.2-a Updated for two RAIDS


log="/Library/Logs/com.trmacs/appleraidcheck.log"
err_log="/Library/Logs/com.trmacs/appleraidcheck-err.log"

exec 1>> "${log}" 
exec 2>> "${err_log}"

when="$(date +%m/%d/%Y%n%H:%M)"

to=`/usr/libexec/PlistBuddy -c  "Print :alerts" /Library/Scripts/trmacs/address.plist`

sw_disk_raw="$(diskutil appleRAID list)"
sw_raid_status_1="$(echo "$sw_disk_raw" | grep "Status:" | awk '{print $2}' | head -1)"
sw_raid_name_1="$(echo "$sw_disk_raw" | grep "Name:" | awk '{print $2}' | head -1)"
sw_raid_status_2="$(echo "$sw_disk_raw" | grep "Status:" | awk '{print $2}' | tail -1)"
sw_raid_name_2="$(echo "$sw_disk_raw" | grep "Name:" | awk '{print $2}' | tail -1)"

raid_good="Online"

# Set the host name for easy identification.
host_raw="$(scutil --get HostName)"

if [ -z "$host_raw" ]; then
	host_name="$(scutil --get ComputerName)"
else	
	host_name="$host_raw"
fi


# Check on RAID #1
if [ "$sw_raid_status_1" != "$raid_good" ]; then

	echo "At "$when" the Internal Apple RAID "$sw_raid_name_1" on "$host_name" is currently "$sw_raid_status_1"." \
    | mail -s ""$host_name" Apple Raid Failure Notice" "$to"; \
 echo "At "$when" the Internal RAID "$sw_raid_name_1" on "$host_name" is currently "$sw_raid_status_1".  \
     An e-mail notification has been sent to "$to"."

else
	echo "At "$when" the Apple Software RAID "$sw_raid_name_1" on "$host_name" is currently "$sw_raid_status_1"."
fi

#-----------------------------------

# Check on RAID #2
if [ "$sw_raid_status_2" != "$raid_good" ]; then

	echo "At "$when" the Internal Apple RAID "$sw_raid_name_2" on "$host_name" is currently "$sw_raid_status_2"." \
    | mail -s ""$host_name" Apple Raid Failure Notice" "$to"; \
 echo "At "$when" the Internal RAID "$sw_raid_name_2" on "$host_name" is currently "$sw_raid_status_2".  \
     An e-mail notification has been sent to "$to"."

else
	echo "At "$when" the Apple Software RAID "$sw_raid_name_2" on "$host_name" is currently "$sw_raid_status_2"."
fi




exit 0