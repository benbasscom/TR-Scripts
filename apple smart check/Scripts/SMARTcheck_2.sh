#!/bin/bash
# Smart check
# Created by Ben Bass
vers="SMARTcheck-0.6.1-a"
# Copyright 2012 Technology Revealed. All rights reserved.
# This script checks the Serial ATA bus for devices and checks their SMART status.
# It then logs the information to a file and will send a notification e-mail if port 25 is open and the SMART fails.
# This works for a computer with 2 drives in place.  Tested on Mac Mini's with an upper and lower bay.
# 0.5.4 added version as a live variable
# 0.6.0 changed "to" variable to pull from address.plist
# 0.6.0-a Updated for 4 drives for silverman
# 0.6.1-a to pulled from settings.plist

log="/Library/Logs/com.trmacs/SMARTcheck.log"
err_log="/Library/Logs/com.trmacs/SMARTcheck-err.log"
exec 1>> "${log}" 
exec 2>> "${err_log}"

to=`/usr/libexec/PlistBuddy -c  "Print :alerts" /Library/Scripts/trmacs/settings.plist`

sw_smart_check_raw="$(system_profiler SPSerialATADataType)"
sw_smart_status_1=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3" "$4}' | head -1)
sw_smart_status_2=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3" "$4}' | head -2 | tail -1)
sw_smart_status_3=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3" "$4}' | tail -2 | head -1)
sw_smart_status_4=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3" "$4}' | tail -1)

smart_good="Verified "
smart_na="Not Supported"
when="$(date +"%A %B %e, %G at %I:%M%p")"
sw_smart_status_1_g=$(echo "$sw_smart_status_1" | sed 's/ //g')
sw_smart_status_2_g=$(echo "$sw_smart_status_2" | sed 's/ //g')
sw_smart_status_3_g=$(echo "$sw_smart_status_3" | sed 's/ //g')
sw_smart_status_4_g=$(echo "$sw_smart_status_4" | sed 's/ //g')

# Set the host name for easy identification.
host_raw="$(scutil --get HostName)"

if [ -z "$host_raw" ]; then
	host_name="$(scutil --get ComputerName)"
else	
	host_name="$host_raw"
fi

sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | sed 's/^.//g' | head -1) 
sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | sed 's/^.//g' | tail -1)  
sw_smart_dev_name_3=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | tail -2 | cut -d : -f 2 | sed 's/ //g' | head -1) 
sw_smart_dev_name_4=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | tail -2 | cut -d : -f 2 | sed 's/ //g' | tail -1)  


# Drive 1 check
if [ "$sw_smart_status_1" == "$smart_na" ]; then
	echo "At "$when" the SMART status of "$sw_smart_dev_name_1" on "$host_name" is currently "$sw_smart_status_1"."
elif [ "$sw_smart_status_1" == "$smart_good" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_1" on "$host_name" is currently "$sw_smart_status_1_g"."
else
	echo "On "$when" the SMART status of "$sw_smart_dev_name_1" on "$host_name" has failed with Status "$sw_smart_status_1"" | mail -s ""$host_name" SMART status failure" "$to"
	echo "On "$when" the SMART status of "$sw_smart_dev_name_1" on "$host_name" is "$sw_smart_status_1". An e-mail notification has been sent to "$to"."
fi

# Drive 2 check
if [ "$sw_smart_status_2" == "$smart_na" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_2" on "$host_name" is currently "$sw_smart_status_2"."
elif [ "$sw_smart_status_2" == "$smart_good" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_2" on "$host_name" is currently "$sw_smart_status_2_g"."
else
	echo "On "$when" the SMART status of "$sw_smart_dev_name_2" on "$host_name" has failed with Status "$sw_smart_status_2"" | mail -s ""$host_name" SMART status failure" "$to"
	echo "On "$when" the SMART status of "$sw_smart_dev_name_2" on "$host_name" is "$sw_smart_status_2". An e-mail notification has been sent to "$to"."
fi

# Drive 3 check
if [ "$sw_smart_status_3" == "$smart_na" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_3" on "$host_name" is currently "$sw_smart_status_3"."
elif [ "$sw_smart_status_3" == "$smart_good" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_3" on "$host_name" is currently "$sw_smart_status_3_g"."
else
	echo "On "$when" the SMART status of "$sw_smart_dev_name_3" on "$host_name" has failed with Status "$sw_smart_status_3"" | mail -s ""$host_name" SMART status failure" "$to"
	echo "On "$when" the SMART status of "$sw_smart_dev_name_3" on "$host_name" is "$sw_smart_status_3". An e-mail notification has been sent to "$to"."
fi

# Drive 4 check
if [ "$sw_smart_status_4" == "$smart_na" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_4" on "$host_name" is currently "$sw_smart_status_4"."
elif [ "$sw_smart_status_4" == "$smart_good" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_4" on "$host_name" is currently "$sw_smart_status_4_g"."
else
	echo "On "$when" the SMART status of "$sw_smart_dev_name_4" on "$host_name" has failed with Status "$sw_smart_status_4"" | mail -s ""$host_name" SMART status failure" "$to"
	echo "On "$when" the SMART status of "$sw_smart_dev_name_4" on "$host_name" is "$sw_smart_status_4". An e-mail notification has been sent to "$to"."
fi


exit 0