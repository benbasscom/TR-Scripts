#!/bin/sh

# Disables Apple Software Update Checks
# When running as a LoginHook DO NOT run as $1 or the local user.
# This needs to be run as root.

softwareupdate --schedule off

exit 0