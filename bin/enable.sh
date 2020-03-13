#!/bin/sh

# change to directory of this script
cd "$(dirname "$0")"

if [ -e /etc/upstart ]; then
	logger "Enabling online pictureframe auto-update"

	chmod 744 /mnt/us/extensions/onlinepictureframe/bin/pictureframe.sh
	mntroot rw
	cp /mnt/us/extensions/onlinepictureframe/bin/pictureframe.conf /etc/upstart/pictureframe.conf
	mntroot ro

	start pictureframe
else
	logger "Upstart folder not found, device too old"
fi
