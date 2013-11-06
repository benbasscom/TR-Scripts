#!/bin/bash -x

# CCC post flight for parsing out the last stats to an individual file for each script.

source_entries=`/usr/libexec/PlistBuddy -c "Print" /Library/Logs/CCC.stats | grep sourceDisk | wc -l`
source_last_entry=$(($source_entries - 1))

	taskName=`/usr/libexec/PlistBuddy -c "Print ${source_last_entry}:cccTaskName" /Library/Logs/CCC.stats`
#	elapsedTime=`/usr/libexec/PlistBuddy -c "Print ${source_last_entry}:elapsedTime" /Library/Logs/CCC.stats`
#	targetDisk=`/usr/libexec/PlistBuddy -c "Print ${source_last_entry}:targetDisk" /Library/Logs/CCC.stats`
#	dataCopied=`/usr/libexec/PlistBuddy -c "Print ${source_last_entry}:dataCopied" /Library/Logs/CCC.stats`
#	date=`/usr/libexec/PlistBuddy -c "Print ${source_last_entry}:date" /Library/Logs/CCC.stats`
#	taskExitStatus=`/usr/libexec/PlistBuddy -c "Print ${source_last_entry}:taskExitStatus" /Library/Logs/CCC.stats`
#	startTime=`/usr/libexec/PlistBuddy -c "Print ${source_last_entry}:startTime" /Library/Logs/CCC.stats`
#	sourceDisk=`/usr/libexec/PlistBuddy -c "Print ${source_last_entry}:sourceDisk" /Library/Logs/CCC.stats`
    
# take each variable and add to it's own plist.
# need to find a way to make each grouping individual.  using the previous last_entry won't work as it will include other tasks and possibly leave us with empty dictionaries.  Possibly destin_count+1?

dest_entries=`/usr/libexec/PlistBuddy -c "Print" /Library/Logs/com.trmacs/ccc_stats/`"$taskName"`.plist | grep sourceDisk | wc -l`
dest_last_entry=$(($dest_entries + 1))

dest_file="$taskName".plist

if [ dest_file -!e ]; then
touch $dest_file
fi

/usr/libexec/PlistBuddy -c "Add ${dest_last_entry}:cccTaskName string "$taskName" /Library/Logs/com.trmacs/ccc_stats/`"$taskName"`.plist

#/usr/libexec/PlistBuddy -c "Add ${dest_last_entry}:elapsedTime real "$elapsedTime" /Library/Logs/com.trmacs/"$taskName".plist
#/usr/libexec/PlistBuddy -c "Add ${dest_last_entry}:targetDisk string "$targetDisk" /Library/Logs/com.trmacs/"$taskName".plist
#/usr/libexec/PlistBuddy -c "Add ${dest_last_entry}:dataCopied real "$dataCopied" /Library/Logs/com.trmacs/"$taskName".plist
#/usr/libexec/PlistBuddy -c "Add ${dest_last_entry}:date date "$date" /Library/Logs/com.trmacs/"$taskName".plist
#/usr/libexec/PlistBuddy -c "Add ${dest_last_entry}:taskExitStatus integer "$taskExitStatus" /Library/Logs/com.trmacs/"$taskName".plist
#/usr/libexec/PlistBuddy -c "Add ${dest_last_entry}:startTime date "$startTime" /Library/Logs/com.trmacs/"$taskName".plist
#/usr/libexec/PlistBuddy -c "Add ${dest_last_entry}:sourceDisk string "$sourceDisk" /Library/Logs/com.trmacs/"$taskName".plist




exit 0


#	Task Name = 	String
#	dataCopies = 	real
#	date = 			date
#	elapsedTime = 	real
#	sourceDisk = 	string
#	startTime = 	date
#	targetDisk=		string
#	taskExitStatus=	integer


/usr/libexec/PlistBuddy -c "Print 55:cccTaskName" /Library/Logs/CCC.stats