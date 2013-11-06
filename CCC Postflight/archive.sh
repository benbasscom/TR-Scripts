#!/bin/bash
# CCC Archiving post flight script v0.9
# Created by Ben Bass
# Copyright 2012 Technology Revealed. All rights reserved.
# This is a CCC post flight script to move Archived folders from the backup drive to a different volume

# Directory CCC initially places the _CCC Archives folder
# STARTDIR=/Volumes/Data\ Offsite/_CCC\ Archives
STARTDIR=/Volumes/Storage/Test/Destination/_CCC\ Archives

# Desired final destination of folders within the _CCC Archives folder
# ARCHDIR=/Volumes/Archive\ Offsite
ARCHDIR=/Volumes/Storage/Test/Archives

# Move the subfolders from the _CCC Archives folder to the Archive directory
# This should last until 2020 as we are searching for a folder starting with 201
# 2012-09-06 (September 06) 15-58-03 is the syntax CCC 3.5.1 uses.

mv "$STARTDIR"/201* "$ARCHDIR"

#Delete archives older than 90 days:

# find "$ARCHDIR" -name '201*' -type d -mtime +180 -print0 | xargs -0 rm -rf

find "$ARCHDIR" -name '201*' -type d -mtime +180 -print0 | xargs -0 rm -rf
