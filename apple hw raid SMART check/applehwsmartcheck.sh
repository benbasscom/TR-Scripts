#!/bin/bash
# Apple Hardware Raid Smart check
vers="applehwsmartcheck-1.3"
# Created by Ben Bass
# Copyright 2012 Technology Revealed. All rights reserved.
# This script checks the Serial ATA bus for devices and checks their SMART status.
# It then logs the information to a file and will send a notification e-mail if port 25 is open and the SMART fails.
# for some reason on disk 2 using the variable $VAR2 as $2 just fails miserable - hence setting to 9.
# 1.3 added vers variable.


to="ben@trmacs.com"
log="/Library/Logs/com.trmacs/SMARTcheck.log"
err_log="/Library/Logs/com.trmacs/SMARTcheck-err.log"
exec 1>> "${log}" 
exec 2>> "${err_log}"

hw_smart_check_raw="$(system_profiler SPHardwareRAIDDataType)"
hw_smart_status_1=$(echo "$hw_smart_check_raw" | grep "SMART Status:" | awk '{print $3}' | head -1)
hw_smart_status_2=$(echo "$hw_smart_check_raw" | grep "SMART Status:" | awk '{print $3}' | head -2 | tail -1)
hw_smart_status_3=$(echo "$hw_smart_check_raw" | grep "SMART Status:" | awk '{print $3}' | tail -1)
hw_smart_dev_name_1=$(echo "$hw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | sed 's/^......//g' | head -1)
hw_smart_dev_name_2=$(echo "$hw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | sed 's/^......//g' | head -2 | tail -1)
hw_smart_dev_name_3=$(echo "$hw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | sed 's/^......//g' | tail -1)

smart_good="Verified"
when="$(date +%m/%d/%Y%n%H:%M)"

# Set the host name for easy identification.
host_raw="$(scutil --get HostName)"

if [ -z "$host_raw" ]; then
	host_name="$(scutil --get ComputerName)"
else	
	host_name="$host_raw"
fi


#-----------------------------------------------------------------------------------------------------

# Drive 1 check
if [ "$hw_smart_status_1" != "$smart_good" ]; then

	echo "At "$when" the SMART status of "$hw_smart_dev_name_1" on "$host_name" has failed with Status "$hw_smart_status_1"" \
| mail -s ""$host_name" SMART status failure" "$to"; \
echo "At "$when" the SMART status of "$hw_smart_dev_name_1" on "$host_name" is "$hw_smart_status_1". \
An e-mail notification has been sent to "$to"."

else
	echo "At "$when" the SMART status of "$hw_smart_dev_name_1" on "$host_name" is currently "$hw_smart_status_1"."
fi

# Drive 2 check
if [ "$hw_smart_status_2" != "$smart_good" ]; then

	echo "At "$when" the SMART status of "$hw_smart_dev_name_2" on "$host_name" has failed with Status "$hw_smart_status_2"" \
| mail -s ""$host_name" SMART status failure" "$to"; \
echo "At "$when" the SMART status of "$hw_smart_dev_name_2" on "$host_name" is "$hw_smart_status_2". \
An e-mail notification has been sent to "$to"."

else
	echo "At "$when" the SMART status of "$hw_smart_dev_name_2" on "$host_name" is currently "$hw_smart_status_2"."
fi

# Drive 3 check
if [ "$hw_smart_status_3" != "$smart_good" ]; then

	echo "At "$when" the SMART status of "$hw_smart_dev_name_3" on "$host_name" has failed with Status "$hw_smart_status_3"" \
| mail -s ""$host_name" SMART status failure" "$to"; \
echo "At "$when" the SMART status of "$hw_smart_dev_name_3" on "$host_name" is "$hw_smart_status_3". \
An e-mail notification has been sent to "$to"."

else
	echo "At "$when" the SMART status of "$hw_smart_dev_name_3" on "$host_name" is currently "$hw_smart_status_3"."
fi
exit 0