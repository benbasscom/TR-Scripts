#!/bin/bash
# Temperature checking and notification script
vers="tempnotify-0.6.1"
# This checks the temperature of A DIODE and compares if it is above 50 C.  If above, 50,
# it is logged and an e-mail notification is sent.  If not above 50, it is just logged.
# Note that tempmonitor has to be installed and either linked or copied to /usr/local/bin.
# 0.6.0 Pulls the "to" variable from the address.plist.
# 0.6.1 Pulls the "to" variable from the settings.plist.

log="/Library/Logs/com.trmacs/tempnotify.log"
err_log="/Library/Logs/com.trmacs/tempnotify-err.log"

exec 1>> "${log}" 
exec 2>> "${err_log}"

to=`/usr/libexec/PlistBuddy -c  "Print :alerts" /Library/Scripts/trmacs/settings.plist`

temp="$(/usr/local/bin/tempmonitor -c -ds -a -l | grep "A DIODE" | awk '{print $5}')"
when="$(date +%m/%d/%Y%n%H:%M)"

# Set the host name for easy identification.
host_raw="$(scutil --get HostName)"

if [ -z "$host_raw" ]; then
	host_name="$(scutil --get ComputerName)"
else	
	host_name="$host_raw"
fi

#-------------------------------------------------------------------------------------------------

if [ "$temp" -ge 100 ]; then

     echo "At "$when" the CPU temperature of "$host_name" is "$temp" degrees and is in danger of overheating" \
     | mail -s ""$host_name" High Temperature Notice" "$to"; \
     echo "At "$when" the CPU temperature of "$host_name" is "$temp" and is NOT within the Acceptable range.  \
     An e-mail notification has been sent to "$to"."

else
     echo "At "$when" the CPU temperature of "$host_name" is "$temp" and within the Acceptable range"
fi

exit 0