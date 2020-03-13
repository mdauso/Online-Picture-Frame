![finisched Picture Frame](https://cafebrick.files.wordpress.com/2020/01/img_6452.jpg "Online Pictureframe")

Online Pictureframe
------------------ v0.1
                   by mdauso, via mobileread.com
                   thanks to the great folks in the Kindle developer corner
                   special thanks to _nico and bugfinder

The Online Pictureframe was written to use a Kindle PW as a Pictureframe.
The Idea is to place the Pictureframe at Grandmas & Grandpas house and
send to them an updated picture once a day or more or less.

The Pictureframe logs in to my private router and loads a special picture
if there is. The picture can be uploaded directly from any device by using
ftp upload.

Once downloaded the picture, imagemagick takes care for the right picture format
to fit to Kindles demands.
 
This script will get the Kindle to sleep and wakes it up at midnight.

The Pictureframe only accepts pictures saved in the following format: “abc.JPG”.
Please note that the picture file name is case sensitive.



Disclaimer
----------
As usual please be advised that you are using this extension on your own risk. 


Prerequisites
-------------

* You must have KUAL v2 or later installed.


Installation
------------

Unzip the downloaded file into the extensions folder (/mnt/us/extensions
when using SSH, otherwise the extensions folder at root of the Kindle volume
when connected to your PC).


Configuration
-------------

Edit the following in onlinepictureframe/bin/pictureframe.sh

#FTPS Server the pictures are located on
USER="xxx"          # FTPS user
PASSWORT="xxx"      # FTPS password
PORT="xxx"          # port of FTPS-Server
FTPADRESSE="xxx"    # DynDNS adress of FTPS server

#Where will the picture frame be located
#HOSTNAME="xxx"
HOSTNAME="xxx"
#HOSTNAME="xxx"

ROUTERIP="192.168.178.1"   # Standard Gateway AVM Fritz!Box
#ROUTERIP="192.168.2.1"    # Standard Gateway Telekom Speedport


Use
---

Run KUAL and enter the "Online-Pictureframe Section". You can also enable or
disable the auto-download.


Uninstalling
------------

It is recommended to disable auto-updates prior to deleting the folder
from the extensions directory.
