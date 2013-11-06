#!/bin/sh

get_last_entry() {
    entries=`/usr/libexec/PlistBuddy -c "Print" /Library/Logs/CCC.stats | grep sourceDisk | wc -l`
    last_entry=$(($entries - 1))
    taskName=`/usr/libexec/PlistBuddy -c "Print ${last_entry}:cccTaskName" /Library/Logs/CCC.stats`
    elapsedTime=`/usr/libexec/PlistBuddy -c "Print ${last_entry}:elapsedTime" /Library/Logs/CCC.stats`
    targetDisk=`/usr/libexec/PlistBuddy -c "Print ${last_entry}:targetDisk" /Library/Logs/CCC.stats`
    dataCopied=`/usr/libexec/PlistBuddy -c "Print ${last_entry}:dataCopied" /Library/Logs/CCC.stats`
    date=`/usr/libexec/PlistBuddy -c "Print ${last_entry}:date" /Library/Logs/CCC.stats`
    taskExitStatus=`/usr/libexec/PlistBuddy -c "Print ${last_entry}:taskExitStatus" /Library/Logs/CCC.stats`
    startTime=`/usr/libexec/PlistBuddy -c "Print ${last_entry}:startTime" /Library/Logs/CCC.stats`
    sourceDisk=`/usr/libexec/PlistBuddy -c "Print ${last_entry}:sourceDisk" /Library/Logs/CCC.stats`
    
    ## Then do something with these variables...
}

$(sleep 5; get_last_entry;) &


plutil -convert xml1 /Library/Logs/CCC.stats -o -



