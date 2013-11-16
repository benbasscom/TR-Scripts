#!/bin/tcsh -f

############################ logout-wrapper.sh ######################
# Originally by Mike Bombich | bombich@apple.com
# Updated by Ben Bass | ben@trmacs.com                
# to make this shell script run each time a user logs out.
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
set scriptLog = /var/log/logouthook.log


### Debug/testing sanity check ###
if ( $#argv < 1 ) then
	echo "No user specified!"
	exit 1
endif

# Create log file if it doesn't exist.  Normally created in installation postflight.
# touch /var/log/logouthook.log

### Script action ###
# Each script must be followed by "$1" to pass the name of the user

$scriptDir/keychain-removal.sh "$1" >> $scriptLog
$scriptDir/usertracking-logout.sh "$1" >> $scriptLog

exit 0
