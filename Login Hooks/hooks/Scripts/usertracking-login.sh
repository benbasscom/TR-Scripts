#!/bin/bash

# Define variables.
username=${1}
timestamp=`date ''+%m-%d-%Y_%H:%M:%S''`
computer=`hostname`
logfile="/var/log/usertracking.log"

# Make sure the log is created in postflight if installed by a package.  If not then
# either create here or manually.
# touch /var/log/usertracking.log

# Echo to log to track user login
echo $username," "$timestamp," "$computer," login" >> "$logfile"

exit 0