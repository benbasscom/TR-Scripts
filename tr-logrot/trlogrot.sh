#!/bin/bash
# Log rotation script
vers="trlogrot-0.9.4"
# Created by Ben Bass
# Copyright 2012 Technology Revealed. All rights reserved.
# This script searches the LOGDIR directory for log files larger than the MAX size.
# It then bzip2's the log file, creates a new log file and places a rollover message in both logs.
# It then cleans up compressed log files older than 180 days.
# 0.9.4 added version as a live variable.


TIME=$2
: ${TIME:="$(date '+%m/%d/%Y %H:%M')"}
WHEN=$3
: ${WHEN:="$(date '+%Y-%m-%d')"}
LOGDIR=/Library/Logs/com.trmacs
MAX="+512k"

find $LOGDIR -name '*.log' -type f -size "$MAX" | while read LOGFILE
do
#	echo $LOGFILE # good for testing
	NEWLOGFILE=$LOGFILE.$WHEN
	mv $LOGFILE $NEWLOGFILE
	echo  "Log file turned over due to size larger than "$MAX" by trlogrot on: "$TIME"" >> $LOGFILE
	echo  "Log file turned over due to size larger than "$MAX" by trlogrot on: "$TIME"" >> $NEWLOGFILE
	bzip2 $NEWLOGFILE &
done

#Delete compressed logs older than 180 days:
find $LOGDIR -name '*.bz2' -type f -mtime +180 | xargs rm -f

exit 0