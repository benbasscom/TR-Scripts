#!/bin/bash
# Smart check version 0.5.1
# Created by Ben Bass
# Copyright 2012 Technology Revealed. All rights reserved.
# This script checks the Serial ATA bus for devices and checks their SMART status.
# It then logs the information to a file and will send a notification e-mail if port 25 is open and the SMART fails.
# This works for a computer with 2 drives in place.


log="/Library/Logs/com.trmacs/SMARTcheck.log"
err_log="/Library/Logs/com.trmacs/SMARTcheck-err.log"
exec 1>> "${log}" 
exec 2>> "${err_log}"

to="ben@trmacs.com"

sw_smart_check_raw="$(system_profiler SPSerialATADataType)"
sw_smart_status_1=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3" "$4}' | head -1)
sw_smart_status_2=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3" "$4}' | tail -1)
smart_good="Verified "
smart_na="Not Supported"
when="$(date +"%A %B %e, %G at %I:%M%p")"
host_name="$(system_profiler SPSoftwareDataType | grep "Computer Name:" | awk '{print $3}')"
sw_smart_status_1_g=$(echo "$sw_smart_status_1" | sed 's/ //g')
sw_smart_status_2_g=$(echo "$sw_smart_status_2" | sed 's/ //g')



# Drive 1 check
if [ "$sw_smart_status_1" == "$smart_na=" ]; then
	echo "At "$when" the SMART status of Drive 1 on "$host_name" is currently "$sw_smart_status_1"."
elif [ "$sw_smart_status_1" == "$smart_good" ]; then
	echo "On "$when" the SMART status of Drive 1 on "$host_name" is currently "$sw_smart_status_1_g"."
else
	echo "On "$when" the SMART status of Drive 1 on "$host_name" has failed with Status "$sw_smart_status_1"" | mail -s ""$host_name" SMART status failure" "$to"
	echo "On "$when" the SMART status of Drive 1 on "$host_name" is "$sw_smart_status_1". An e-mail notification has been sent to "$to"."
fi

# Drive 2 check
if [ "$sw_smart_status_2" == "$smart_na=" ]; then
	echo "On "$when" the SMART status of Drive 2 on "$host_name" is currently "$sw_smart_status_2"."
elif [ "$sw_smart_status_2" == "$smart_good" ]; then
	echo "On "$when" the SMART status of Drive 2 on "$host_name" is currently "$sw_smart_status_2_g"."
else
	echo "On "$when" the SMART status of Drive 2 on "$host_name" has failed with Status "$sw_smart_status_2"" | mail -s ""$host_name" SMART status failure" "$to"
	echo "On "$when" the SMART status of Drive 2 on "$host_name" is "$sw_smart_status_2". An e-mail notification has been sent to "$to"."
fi

exit 0