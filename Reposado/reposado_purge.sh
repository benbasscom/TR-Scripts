#!/bin/bash
# Reposado purge
# Created by Ben Bass
vers="reposado_purge-0.1"
# Copyright 2013 Technology Revealed. All rights reserved.
# Determines the deprecated items in Reposado and purges them.
# 0.1 - Initial try.

log_when=$(date +%Y-%m-%d)

# Set log files for stdout & stderror
log="/Library/Logs/com.trmacs/reposado_purge.log"
err_log="/Library/Logs/com.trmacs/reposado_purge-error.log"



# Set Variables

repoutil=/usr/local/reposado/code/repoutil

# command to generate the list of deprecated items.
deprecated=$($repoutil --deprecated | awk '{ print $1 }' | tr '\n' ' ')

echo "$deprecated"

# Run the purge command on the list generated.
$repoutil --purge-products=$deprecated