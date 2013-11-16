#!/bin/bash
# login script
vers="hcc_login-1.6.0"
# 1.5.4 adding full UUID for the new Mac Pro's.  Being lazy and having both won't hurt anything
# 1.5.7 fixed a typo
# 1.5.8 added MacPro2,1 logic.
# 1.5.9 - keep in sync with logouthook.
# 1.6.0 - added software update suppression.


username=${1}
timestamp=`date ''+%m-%d-%Y_%H:%M:%S''`
computer=`hostname`
logfile="/var/log/usertracking.log"
sphard="$(system_profiler SPHardwareDataType)"
model_id="$(echo "$sphard" | grep "Model Identifier:" | awk '{print $3}')"

if [ "$model_id" == "MacPro2,1" ]; then
	uuid="$(echo "$sphard" | grep "Hardware UUID:" | awk '{print $3}' | cut -d \- -f5)"
else
	uuid="$(echo "$sphard" | grep "Hardware UUID:" | awk '{print $3}')"
fi

echo $username," "$timestamp," "$computer," login" >> "$logfile"

defaults write /Users/$username/Library/Preferences/ByHost/com.apple.network.eapolcontrol."$uuid" EthernetAutoConnect -bool false
chown -v $username /Users/$username/Library/Preferences/ByHost/com.apple.network.eapolcontrol."$uuid".plist

sleep 2

softwareupdate --schedule off

exit 0