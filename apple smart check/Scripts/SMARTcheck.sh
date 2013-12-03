#!/bin/bash
# Smart check
# Created by Ben Bass
vers="SMARTcheck-0.6.2"
# Copyright 2012 Technology Revealed. All rights reserved.
# This script checks the Serial ATA bus for devices and checks their SMART status.
# It then logs the information to a file and will send a notification e-mail if port 25 is open and the SMART fails.
# This works for a computer with 2 drives in place.  Tested on Mac Mini's with an upper and lower bay.
# 0.5.4 added version as a live variable
# 0.6.0 changed "to" variable to pull from address.plist
# 0.6.1 changed "to" variable to pull from settings.plist
# 0.6.2 Adding Computer SN and model info to report e-mail.

log="/Library/Logs/com.trmacs/SMARTcheck.log"
err_log="/Library/Logs/com.trmacs/SMARTcheck-err.log"
exec 1>> "${log}" 
exec 2>> "${err_log}"

to=`/usr/libexec/PlistBuddy -c  "Print :alerts" /Library/Scripts/trmacs/settings.plist`

sw_smart_check_raw="$(system_profiler SPSerialATADataType)"
sw_smart_status_1=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3" "$4}' | head -1)
sw_smart_status_2=$(echo "$sw_smart_check_raw" | grep "S.M.A.R.T" | awk '{print $3" "$4}' | tail -1)
smart_good="Verified "
smart_na="Not Supported"
when="$(date +"%A %B %e, %G at %I:%M%p")"
sw_smart_status_1_g=$(echo "$sw_smart_status_1" | sed 's/ //g')
sw_smart_status_2_g=$(echo "$sw_smart_status_2" | sed 's/ //g')

# Set the host name for easy identification.
host_raw="$(scutil --get HostName)"

if [ -z "$host_raw" ]; then
	host_name="$(scutil --get ComputerName)"
else	
	host_name="$host_raw"
fi


hw_info_raw="$(system_profiler SPHardwareDataType)"
hw_info_sn="$(echo "$hw_info_raw" | grep "Serial Number" | awk '{print $4}')"
hw_info_model="$(echo "$hw_info_raw" | grep "Model Identifier" | awk '{print $3}')"
hw_info_model_chck="$(echo "$hw_info_model" | cut -c -7)" 

#Check if a mac mini or not.  
if [ "$hw_info_model_chck" = "Macmini" ]; then
	sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | sed 's/^.//g' | head -1) 
	sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Bay Name:" | cut -d : -f 2 | sed 's/^.//g' | tail -1)  

else 
	sw_smart_dev_name_1=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | head -1) 
	sw_smart_dev_name_2=$(echo "$sw_smart_check_raw" | grep "Serial Number:" | cut -d : -f 2 | awk '{print $1}' | tail -1) 
fi


# Drive 1 check
if [ "$sw_smart_status_1" == "$smart_na" ]; then
	echo "At "$when" the SMART status of "$sw_smart_dev_name_1" on "$host_name" is currently "$sw_smart_status_1"."
elif [ "$sw_smart_status_1" == "$smart_good" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_1" on "$host_name" is currently "$sw_smart_status_1_g"."
else
	os_chck="$(system_profiler SPSoftwareDataType | grep "System Version:" | cut -d : -f2 | sed 's/ //')"
	echo -e \
	"Computer Name:"'\t''\t'"$host_name"'\n' 		\
	"Model:"'\t''\t''\t'"$hw_info_model"'\n'		\
	"Host OS:"'\t''\t'"$os_chck"'\n'		\
	"Serial #:"'\t''\t'"$hw_info_sn"'\n'		\
	"Date:"'\t''\t''\t'"$(date +%m/%d/%Y)"'\n'		\
	"Time:"'\t''\t''\t'"$(date +%H:%M)"'\n'		\
	"Disk 1 Identifier:"'\t'"$sw_smart_dev_name_1"'\n'			\
	"Disk 1 Status:"'\t''\t'"$sw_smart_status_1"'\n'			\
	"Disk 2 Identifier:"'\t'"$sw_smart_dev_name_2"'\n'			\
	"Disk 1 Status:"'\t''\t'"$sw_smart_status_2"'\n'			\
	| mail -s ""$host_name" S.M.A.R.T. Failure Notice" "$to"; \
	echo "On "$when" the SMART status of "$sw_smart_dev_name_1" on "$host_name" is "$sw_smart_status_1". An e-mail notification has been sent to "$to"."
fi

# Drive 2 check
if [ "$sw_smart_status_2" == "$smart_na" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_2" on "$host_name" is currently "$sw_smart_status_2"."
elif [ "$sw_smart_status_2" == "$smart_good" ]; then
	echo "On "$when" the SMART status of "$sw_smart_dev_name_2" on "$host_name" is currently "$sw_smart_status_2_g"."
else
	os_chck="$(system_profiler SPSoftwareDataType | grep "System Version:" | cut -d : -f2 | sed 's/ //')"
	echo -e \
	"Computer Name:"'\t''\t'"$host_name"'\n' 		\
	"Model:"'\t''\t''\t'"$hw_info_model"'\n'		\
	"Host OS:"'\t''\t'"$os_chck"'\n'		\
	"Serial #:"'\t''\t'"$hw_info_sn"'\n'		\
	"Date:"'\t''\t''\t'"$(date +%m/%d/%Y)"'\n'		\
	"Time:"'\t''\t''\t'"$(date +%H:%M)"'\n'		\
	"Disk 1 Identifier:"'\t'"$sw_smart_dev_name_1"'\n'			\
	"Disk 1 Status:"'\t''\t'"$sw_smart_status_1"'\n'			\
	"Disk 2 Identifier:"'\t'"$sw_smart_dev_name_2"'\n'			\
	"Disk 1 Status:"'\t''\t'"$sw_smart_status_2"'\n'			\
	| mail -s ""$host_name" S.M.A.R.T. Failure Notice" "$to"; \
	echo "On "$when" the SMART status of "$sw_smart_dev_name_2" on "$host_name" is "$sw_smart_status_2". An e-mail notification has been sent to "$to"."
fi

exit 0