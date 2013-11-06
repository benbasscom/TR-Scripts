#!/bin/bash
# Apple software RAID check
# Created by Ben Bass
vers="appleraidcheck-0.9.5"
# Copyright 2012 Technology Revealed. All rights reserved.
# This script checks the internal Apple Software Raid to see if it is degraded.
# It logs this to a file and if degraded sends an e-mail.
# 0.9.1 now has the version as a live variable.
# 0.9.2 Pulls the "to" variable from the address.plist.
# 0.9.5 Adding Computer SN and model info to report e-mail.

log="/Library/Logs/com.trmacs/appleraidcheck.log"
err_log="/Library/Logs/com.trmacs/appleraidcheck-err.log"

exec 1>> "${log}" 
exec 2>> "${err_log}"

when="$(date +%m/%d/%Y%t%H:%M)"
to=`/usr/libexec/PlistBuddy -c  "Print :alerts" /Library/Scripts/trmacs/address.plist`

####
# Calling diskutil once, and setting variables.  Not all are needed if the RAID is good
# but setting them now is easier since we just call diskutil once if the RAID is good or not.
###

sw_disk_raw="$(diskutil appleRAID list)"
sw_raid_status="$(echo "$sw_disk_raw" | grep "Status:" | awk '{print $2}')"
sw_raid_name="$(echo "$sw_disk_raw" | grep "Name:" | cut -d : -f2 | cut -c 18-)"
sw_raid_member1_status="$(echo "$sw_disk_raw" | grep "0  disk" | awk '{print $4}')"
sw_raid_member2_status="$(echo "$sw_disk_raw" | grep "1  disk" | awk '{print $4}')"
sw_raid_member1_disk="$(echo "$sw_disk_raw" | grep "0  disk" | awk '{print $2}')"
sw_raid_member2_disk="$(echo "$sw_disk_raw" | grep "1  disk" | awk '{print $2}')"

# Set the variable if the RAID is functional.  If the RAID is anything else, we phone home.
raid_good="Online"

# Set the host name for easy identification.
host_raw="$(scutil --get HostName)"

if [ -z "$host_raw" ]; then
	host_name="$(scutil --get ComputerName)"
else	
	host_name="$host_raw"
fi

####
# Checking if the RAID matches "Online".  If not, get info about the computer and devices and send an e-mail.
# Also log that the e-mail was sent.
# If the RAID is good, log date time, RAID name, computer name and status to a log file.
###

if [ "$sw_raid_status" != "$raid_good" ]; then

# If the Raid is good, no need to run SPHardwareDataType or SPSerialATADataType.  So only called when the RAID fails.

hw_info_raw="$(system_profiler SPHardwareDataType)"
hw_info_sn="$(echo "$hw_info_raw" | grep "Serial Number" | awk '{print $4}')"
hw_info_model="$(echo "$hw_info_raw" | grep "Model Identifier" | awk '{print $3}')"
hw_info_model_chck="$(echo "$hw_info_model" | cut -c -7)" 
os_chck="$(system_profiler SPSoftwareDataType | grep "System Version:" | cut -d : -f2 | sed 's/ //')"

sw_smart_check_raw="$(system_profiler SPSerialATADataType)"

	if [ "$hw_info_model_chck" = "Macmini" ]; then
		sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | sed 's/^.//g' | head -1) 
		sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | sed 's/^.//g' | tail -1)  

	else 
		sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | head -1) 
		sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | tail -1) 
	fi

	echo -e \
	"Computer Name:"'\t''\t'"$host_name"'\n' 		\
	"Model:"'\t''\t''\t'"$hw_info_model"'\n'		\
	"Host OS:"'\t''\t'"$os_chck"'\n'		\
	"Serial #:"'\t''\t'"$hw_info_sn"'\n'		\
	"Date:"'\t''\t''\t'"$(date +%m/%d/%Y)"'\n'		\
	"Time:"'\t''\t''\t'"$(date +%H:%M)"'\n'		\
	"Raid Name:"'\t''\t'"$sw_raid_name"'\n'		\
	"Raid Status:"'\t''\t'"$sw_raid_status"'\n''\n'			\
	"Member 1 Status:"'\t'"$sw_raid_member1_status"'\n'			\
	"Member 1 Disk:"'\t''\t'"$sw_raid_member1_disk"'\n'			\
	"Member 1 Identifier:"'\t'"$sw_smart_dev_name_1"'\n'			\
	"Member 2 Status:"'\t'"$sw_raid_member2_status"'\n'			\
	"Member 2 Disk:"'\t''\t'"$sw_raid_member2_disk"'\n'			\
	"Member 2 Identifier:"'\t'"$sw_smart_dev_name_2"'\n'			\
	| mail -s ""$host_name" Apple Raid Failure Notice" "$to"; \
	echo "At "$when" the Internal RAID "$sw_raid_name" on "$host_name" is currently "$sw_raid_status".  \
	An e-mail notification has been sent to "$to"."
else
	echo "At "$when" the Apple Software RAID "$sw_raid_name" on "$host_name" is currently "$sw_raid_status"."
fi

exit 0