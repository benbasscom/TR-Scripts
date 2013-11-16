#!/bin/bash
# logout script
vers="hcc_logout-1.6.0"
# Logs the name of the user to a log file on log out, and deletes the users login keychain.
# 1.5.8 - Changed from mv'ing to the trash to rm'ing the keychain.
# 1.5.9 - fixed a typo.
# 1.6.0 - Parity for login.

username=${1}
timestamp=`date ''+%m-%d-%Y_%H:%M:%S''`
computer=`hostname`
logfile="/var/log/usertracking.log"

echo $username," "$timestamp," "$computer," logout" >> "$logfile"
rm -rf /Users/$username/Library/Keychains/login.keychain

exit 0
