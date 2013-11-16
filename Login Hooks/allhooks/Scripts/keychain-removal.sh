#!/bin/bash
# Removes the default login keychain.  Great for labs with AD accounts that aren't 
# tied to specific computer.

username=${1}

rm /Users/$username/Library/Keychains/login.keychain

# writing to the log to track keychain removals.
echo "removing "${username}"'s keychain at "$(date +%Y-%m-%d-%H-%M)""

exit 0