#!/bin/sh
# change to directory of this script
cd "$(dirname "$0")"

	### Send Log File to FTP Folder
	/mnt/us/usbnet/bin/curl -T /mnt/us/extensions/onlinepictureframe/bin/pictureframe.log ftp://mdauso:Hecke2009@mario-deuse.my-router.de:21/Logfiles/ 

