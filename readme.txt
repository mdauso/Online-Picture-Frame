Online Pictureframe
------------------ v0.1
                   by mdauso, via mobileread.com
                   thanks to the great folks in the Kindle developer corner
                   special thanks to _nico and bugfinder

The Online Pictureframe was written to use a Kindle PW as a Pictureframe.
The Idea is to place the Pictureframe at Grandma´s & Grandpa´s house and
send to them an updated picture once a day or more or less.

The Pictureframe logs in to my private router and loads a special picture
if there is. The picture can be uploaded directly from any device by using
ftp upload.

Once downloaded the picture, imagemagick takes care for the right picture format
to fit to Kindles demands.
 
This script will get the Kindle to sleep and wakes it up after a defined
amount of seconds. This sleep time is definded in pictureframe.sh as
SUSPENDFOR=. Default is two times a day starting with script activation in KUAL.

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

Edit SUSPENDFOR= in onlinepictureframe/bin/pictureframe.sh


Use
---

Run KUAL and enter the "Online-Pictureframe Section". You can also enable or
disable the auto-download.


Uninstalling
------------

It is recommended to disable auto-updates prior to deleting the folder
from the extensions directory.
