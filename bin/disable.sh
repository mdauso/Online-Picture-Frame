#!/bin/sh

# change to directory of this script
cd "$(dirname "$0")"

# forever and ever, try to update the screensaver
logger "Disabling online pictureframe auto-update"

stop pictureframe || true      

mntroot rw
rm /etc/upstart/pictureframe.conf
mntroot ro
