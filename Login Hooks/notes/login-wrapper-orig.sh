#!/bin/tcsh -f

############################ login-wrapper.sh ######################
# Originally by Mike Bombich | bombich@apple.com                
# Updated by Ben Bass | ben@trmacs.com                
# to make this shell script run each time a user logs in.
####################################################################


### Description ###
#
# This script launches other scripts, passing the appropriate
# parameters. You can use this script to combine the functionality
# of multiple scripts without combining their contents.


### Properties ###
#
# Make sure to add the scripts you want to run in the scriptDir.
# scriptDir: The directory in which you store your shell scripts
# scriptLog: The location of a log file.  Set to  /dev/null
# for no log
set scriptDir = /usr/local/bin/scripts
set scriptLog = /var/log/loginhook.log


### Debug/testing sanity check ###
if ( $#argv < 1 ) then
	echo "No user specified!"
	exit 1
endif

# Create log file if it doesn't exist.  Normally created in installation postflight.
# touch /var/log/loginhook.log

### Script action ###
# Each script must be followed by "$1" or a username to pass the name of the user

$scriptDir/SoftwareUpdateSuppression.sh root >> $scriptLog
$scriptDir/usertracking-login.sh "$1" >> $scriptLog

exit 0
