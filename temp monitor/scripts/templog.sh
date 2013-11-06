#!/bin/bash
vers="templog-0.3.1"
# 0.3.1 added vers as a live variable

# logs the current temp readings to a csv file.

/usr/local/bin/tempmonitor -tv >> /Library/Logs/com.trmacs/templog.csv