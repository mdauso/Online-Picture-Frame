![finisched Picture Frame](https://cafebrick.files.wordpress.com/2020/01/img_6452.jpg "Online Pictureframe")

**Online Pictureframe V010**
--------------------------------------------------------------------------------------

by mdauso, via mobileread.com
thanks to the great folks in the Kindle developer corner
special thanks to _nico and bugfinder

The Online Pictureframe was written to use a Kindle PW as a Pictureframe.
The Idea is to place the Pictureframe at Grandmas & Grandpas house and
send to them an updated picture once a day or more or less.

The Pictureframe logs in to a FTPS server and loads a special picture
if there is. The picture can be uploaded directly from any device by using
ftp upload.

Once downloaded the picture, imagemagick takes care for the right picture format
to fit to Kindles demands and updates the screen.
 
This script will get the Kindle to sleep and wakes it up at midnight.

The Pictureframe only accepts pictures saved in the following format: “abc.JPG”.
Please note that the picture file name is case sensitive.

By have a folder named "newscript" you are able to place an updated pictureframe.sh
script there. The kindle will check for a new script on the FTPS server and if
there it will be downloaded, installed and the kindle will be rebooted to run the
new script. ThereS no need to place the script on the kindle by using SSH or USB. 

If you want to stop the script from running press kindles button for more than 20 sec.
The kindle wil restart. Once started you have 2 minutes to go tho KUAL and disable
auto download in Online-Pictureframe section.



Disclaimer
----------
As usual please be advised that you are using this extension on your own risk. 


Prerequisites
-------------

You must have KUAL v2 or later installed.


Installation
------------

Unzip the downloaded file into the extensions folder (/mnt/us/extensions
when using SSH, otherwise the extensions folder at root of the Kindle volume
when connected to your PC).


Configuration
-------------

Edit the following in onlinepictureframe/bin/pictureframe.sh

FTPS Server the pictures are located on
---------------------------
**You user name for the FTPS server**

USER="xxx"

**Your password for the FTPS server**

PASSWORT="xxx"

**The port for the FTPS server**

PORT="xxx"

**the server adress**

FTPADRESSE="xxx"     

**Where will the picture frame be located**

HOSTNAME="xxx"

**Standard Gateway AVM Fritz!Box**

ROUTERIP="192.168.178.1"   


Use
---
Run KUAL and enter the "Online-Pictureframe Section". You can enable or
disable the auto-download.


Uninstalling
------------
It is recommended to disable auto-updates prior to deleting the folder
from the extensions directory.
