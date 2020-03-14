#!/bin/sh

###########################################################
### Programmer: Nico Hartung <nicohartung1@googlemail.com>#
### chnaged for Picture Frame Mario Deuse <mdauso@web.de> #
###########################################################

###########################################################
## Install                                                #
## copy onlinepictureframe folder to mnt/us/extensions/   #
## activate or deaktivate as usual in KUAL                #
###########################################################

#VERSION
# - 20200307_V010
# - due to it´s speed on paperwhite 2 the script ends before midnight
#   60 seconds added to make shure the script sets the wakeup time to next day

# - 20200218_V009
# - status bar deactivated

# - 20200217_V008
# - imagemagick optimized for better dithering and cropping of pictures to fill screen even
#   if the aspect ration doesn`t fit to screen aspect ratio
#   to prevent from bars on upper and lower side of the picture

# - 20200212_V007
# - checking for new script on server, copy to script direction and reboot
# - Hostname added for picture frame location

# - 20200212_V006
# - V005 not used
# - DynDNS from MyFritz used from now on
# - tmp folder removed from script,
#   downloaded pictures will now be stored inside bin folder,

# - 20200207_V004
# - usage of FTPS instead of FTP from now on

# - 20200206_V003
# - V002 not used
# - sleep 4 min after STR when battery level is low, when connecting charger the Kindle wakes up but the battery
# - will not be over minimum level and the script would go into STR again




############################################################
# Variables
NAME=pictureframe
NAMEOLD=pictureframe_old
SCRIPTDIR="/mnt/us/extensions/onlinepictureframe/bin/"
TEMPDIR="/mnt/us/documents/"
LOG="${SCRIPTDIR}/${NAME}.log"
LOGOLD="${SCRIPTDIR}/${NAMEOLD}.log"


#FTPS Server the pictures are located on
USER="xxx"                                                    # FTPS user
PASSWORT="xxx"                                                # FTPS password
PORT="xxx"                                                    # port of FTPS-Server
FTPADRESSE="xxx"                                              # DynDNS adress of FTPS server

#Where will the picture frame be located
#HOSTNAME="xxx"
HOSTNAME="xxx"
#HOSTNAME="xxx"

ROUTERIP="192.168.178.1"                                    # Standard Gateway AVM Fritz!Box
#ROUTERIP="192.168.2.1"                                     # Standard Gateway Telekom Speedport

#!!!Be sure to have this folder structure on FTPS-Sever or change the script here!!!
ORT="/Bilderrahmen/Bilder/${HOSTNAME}/abc.JPG"              # location of picture on server
FTPLOG="/Bilderrahmen/Logfiles/${HOSTNAME}/"                # location of Logfile on server
NEWSCRIPT="/Bilderrahmen/Newscript/${HOSTNAME}/${NAME}.sh"  # new script on server

#!!!The picture on FTPS-server must have the right name and ending: "abc.JPG" !!!
TEMPFILEJPG="${SCRIPTDIR}/abc.jpg"
TEMPFILEPNG="${SCRIPTDIR}/abc.png"

LOGCOUNTER=0                                                # number of Log entries
LOGCOUNTERALL=1                                             # number of Log´s

NET="wlan0"

LIMG="${SCRIPTDIR}"
LIMGBATT="${SCRIPTDIR}/pictureframebattery.png"
LIMGERR="${SCRIPTDIR}/pictureframeerror_image.png"
LIMGERRWLAN="${SCRIPTDIR}/pictureframeerror_wlan.png"
LIMGWEISS="${SCRIPTDIR}/weiss.png"
LIMGNEWSCRIPT="${SCRIPTDIR}/newscript.png"


SUSPENDFORS=600                                             # short sleeping time in case of ERROR
BATTERYALERT=10                                             # from this Battery Level on to lower values a info will be displayed
BATTERYLOW=6                                                # from this Battery Level on to lower values the picture frame will go into STR an show a "Please Charge Picture"
BATTERYSLEEP=432000                                         # 5 days sleep time when Battery Level is equal or below "BATTERYLOW"

###################################################################################
### Functions
kill_kindle() {
  initctl stop framework    > /dev/null 2>&1                # "powerd_test -p" doesnt work, other command found
  initctl stop cmd          > /dev/null 2>&1
  initctl stop phd          > /dev/null 2>&1
  initctl stop volumd       > /dev/null 2>&1
  initctl stop tmd          > /dev/null 2>&1
  initctl stop webreader    > /dev/null 2>&1
  killall lipc-wait-event   > /dev/null 2>&1
}

customize_kindle() {
  mkdir /mnt/us/update.bin.tmp.partial                      # prevent from Amazon updates
  touch /mnt/us/WIFI_NO_NET_PROBE                           # do not perform a WLAN test
}

#return true if keyword not found
wait_wlan() {
  return `lipc-get-prop com.lab126.wifid cmState | grep CONNECTED | wc -l`
}

###################################################################################
### Script

### stop Kindle pocesses
kill_kindle

### customize Kindle
customize_kindle

###################################################################################
### Loop

while true; do

	echo "." >> ${LOG} 2>&1
	echo "." >> ${LOG} 2>&1
	echo "========================================================" >> ${LOG} 2>&1
	
	echo "`date '+%Y-%m-%d_%H:%M:%S'` Logbucheintrag Nr. ${LOGCOUNTER} von Logbuch Nr. ${LOGCOUNTERALL}" >> ${LOG} 2>&1
	
	echo "========================================================" >> ${LOG} 2>&1

### activate CPU Powersave
	echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo "`date '+%H:%M:%S'` CPU runtergetaktet." >> ${LOG} 2>&1

### switch off screen saver
	lipc-set-prop com.lab126.powerd preventScreenSaver 1 >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Bildschirmschoner ausgeschaltet." >> ${LOG} 2>&1
	
### switch off the top status bar
	lipc-set-prop com.lab126.pillow disableEnablePillow disable
	
	#lipc-set-prop com.lab126.pillow interrogatePillow '{"pillowId": "default_status_bar", "function": "nativeBridge.hideMe();"}'
	#PILLOW_SOFT_DISABLED="yes"
	echo "`date '+%H:%M:%S'` Statusleiste deaktiviert." >> ${LOG} 2>&1

### check battery level and maybe start STR
  CHECKBATTERY=`gasgauge-info -s`
if [ ${CHECKBATTERY} -le ${BATTERYLOW} ]; then
	echo "`date '+%H:%M:%S'`  Akkuladung bei 5%, statisches Batteriezustandsbild gesetzt!" >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'`  Logfile an Sever gesendet." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'`  STR, bitte Akku aufladen!" >> ${LOG} 2>&1
	eips -f -g "${LIMGBATT}"
	/mnt/us/usbnet/bin/curl -T ${LOG} -k --ftp-ssl --tlsv1 --ftp-ssl-reqd --ftp-pasv ftp://${USER}:${PASSWORT}@${FTPADRESSE}:${PORT}/${FTPLOG}           # send Logfile to server
	rtcwake -d /dev/rtc1 -m no -s ${BATTERYSLEEP}                                                                                                        # picture frame will sleep for X days or wakes up in case of charging.
	echo "mem" > /sys/power/state
	sleep 300                                                                                                                                            # waiting time when charging until battery level is higher than "BATTERYLOW" otherwise it will fall into sleep again
else
	echo "`date '+%H:%M:%S'` Verbleibende Akkuladung: `gasgauge-info -c` "  >> ${LOG} 2>&1
fi

### activate WLAN
	lipc-set-prop com.lab126.wifid enable 1 >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` WLAN aktivieren. " >> ${LOG} 2>&1

	WLANNOTCONNECTED=0
	WLANCOUNTER=0
	SHORTSUSPEND=0

### wait for WLAN
while wait_wlan; do
  if [ ${WLANCOUNTER} -gt 30 ]; then
	echo "`date '+%H:%M:%S'` Kein bekanntes WLAN verfügbar." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` DEBUG ifconfig > `ifconfig ${NET}`" >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` DEBUG cmState > `lipc-get-prop com.lab126.wifid cmState`" >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` DEBUG signalStrength > `lipc-get-prop com.lab126.wifid signalStrength`" >> ${LOG} 2>&1
	eips -f -g "${LIMGERRWLAN}"
	WLANNOTCONNECTED=1
	SHORTSUSPEND=1                                                                                                                                       #short sleeptime will be activated 
	break
  fi
	let WLANCOUNTER=WLANCOUNTER+1
	echo "`date '+%H:%M:%S'` | ${HOSTNAME} | Warte auf WLAN (Versuch ${WLANCOUNTER})." >> ${LOG} 2>&1
	sleep 1
done


### connected to WLAN?
if [ ${WLANNOTCONNECTED} -eq 0 ]; then
	echo "`date '+%H:%M:%S'` Mit WLAN verbunden." >> ${LOG} 2>&1

### lost Standard Gateway if WLAN`s not available
	GATEWAY=`ip route | grep default | grep ${NET} | awk '{print $3}'`
	echo "`date '+%H:%M:%S'` ausgelesener Standard-Gateway:  ${GATEWAY}." >> ${LOG} 2>&1
  if [ -z "${GATEWAY}" ]; then
	route add default gw ${ROUTERIP} >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Standard-Gateway nach Sleep nicht mehr vorhanden." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Standard-Gateway wird neu auf ${ROUTERIP} gesetzt." >> ${LOG} 2>&1
  fi

### Check new Script
    /mnt/us/usbnet/bin/curl --silent --time-cond ${SCRIPTDIR}/${NAME}.sh --output ${TEMPDIR}/${NAME}.sh -k --ftp-ssl --tlsv1 --ftp-ssl-reqd --ftp-pasv ftp://${USER}:${PASSWORT}@${FTPADRESSE}:${PORT}/${NEWSCRIPT}
	#-r File Name  (File exists and is readable) 
  if [ -r ${TEMPDIR}/${NAME}.sh ]; then
		cp ${TEMPDIR}/${NAME}.sh ${SCRIPTDIR}/${NAME}.sh
		rm ${TEMPDIR}/${NAME}.sh
		echo "`date '+%H:%M:%S'` Skript aktualisiert, Neustart durchführen." >> ${LOG} 2>&1
		chmod 777 ${SCRIPTDIR}/${NAME}.sh
		eips -f -g ${LIMGNEWSCRIPT}
		sleep 5
		reboot
		exit
	else
	echo "`date '+%H:%M:%S'` Kein neues Skript auf dem Server gefunden." >> ${LOG} 2>&1
  fi
	

### download picture and send to screen

### download using cURL
	/mnt/us/usbnet/bin/curl -k --ftp-ssl --tlsv1 --ftp-ssl-reqd --ftp-pasv ftp://${USER}:${PASSWORT}@${FTPADRESSE}:${PORT}/${ORT} -o ${TEMPFILEJPG}

### Is there any picture?
	#-r File Name  (File exists and is readable) 
  if [ -r ${TEMPFILEJPG} ]; then
	echo "`date '+%H:%M:%S'` Bild auf Server gefunden und heruntergeladen." >> ${LOG} 2>&1

### edit picture with Imagemagick to fulfill eips demands
	/mnt/us/linkss/bin/convert ${TEMPFILEJPG} -auto-orient -filter LanczosSharp -brightness-contrast 3x15 -resize x758 -gravity center -crop 1024x758+0+0 +repage -rotate 270 -colorspace Gray -dither FloydSteinberg -remap /mnt/us/linkss/etc/kindle_colors.gif -quality 75 -define png:color-type=0 -define png:bit-depth=8 ${TEMPFILEPNG}

	echo "`date '+%H:%M:%S'` Bild mit Imagemagick bearbeitet." >> ${LOG} 2>&1

### send picture to screen
	eips -f -g ${LIMGWEISS}           #cover the screen in white to prevent from shadows
	sleep 1                           #let´s sleep a second, e-ink´s are not the fastest
	eips -f -g ${TEMPFILEPNG}         #load picture to screen
	echo "`date '+%H:%M:%S'` Bildschirm aktualisiert." >> ${LOG} 2>&1
  else 
	eips -f -g ${LIMGWEISS}           #cover the screen in white to prevent from shadows
	sleep 1                           #let´s sleep a second, e-ink´s are not the fastest
	eips -f -g ${LIMGERR}             #show error picture
	echo "`date '+%H:%M:%S'` Kein Bild gefunden, Error-Bild gesetzt." >> ${LOG} 2>&1
	SHORTSUSPEND=1                    #short sleep time will be activated
  fi

### delete temp. files
	rm ${TEMPFILEJPG}
	rm ${TEMPFILEPNG}
	echo "`date '+%H:%M:%S'` Temporaere Dateien entfernt." >> ${LOG} 2>&1
	
if [ ${CHECKBATTERY} -le ${BATTERYALERT} ]; then
	eips 2 2 -h " Akku bei 10 Prozent, bitte aufladen "
fi

fi

### calculate and set WAKEUPTIMER
if [ ${SHORTSUSPEND} -eq 1 ]; then
	TODAY=$(date +%s)
	WAKEUPTIME=$(( ${TODAY} + ${SUSPENDFORS} ))
	echo "." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Ein Fehler ist aufgetreten, neuer Versuch am: `date -d @${WAKEUPTIME} '+%Y-%m-%d_%H:%M:%S'`" >> ${LOG} 2>&1
	echo "." >> ${LOG} 2>&1
	rtcwake -d /dev/rtc1 -m no -s ${SUSPENDFORS}
else
	TOMORROW=$(date +%s -d 23:59)
	TODAY=$(date +%s)
	SUSPENDFORL=$((${TOMORROW} - ${TODAY} + 120)) #120 seconds added to make shure it´s past midnight
	WAKEUPTIME=$((${TODAY} + ${SUSPENDFORL}))
	echo "." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Alles OK, Bilderrahmen wird am: `date -d @${WAKEUPTIME} '+%Y-%m-%d_%H:%M:%S'` neu gestartet" >> ${LOG} 2>&1
	echo "." >> ${LOG} 2>&1
	rtcwake -d /dev/rtc1 -m no -s ${SUSPENDFORL}

fi

### at 365 Log entries the Log will be saved as "pictureframe_old.log" on FTP server, the Log on Kindle will be deleted and a new Log will be created with number +1
	let LOGCOUNTER=LOGCOUNTER+1
if [ ${LOGCOUNTER} -gt 365 ]; then
	cp ${LOG} ${LOGOLD}
	echo "`date '+%H:%M:%S'` Alter Logfile wird auf dem Sever gesichert und vom Bilderrahmen geloescht." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Ruhezustand wird gestartet." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Bye Bye!" >> ${LOG} 2>&1
	/mnt/us/usbnet/bin/curl -T ${LOGOLD} -k --ftp-ssl --tlsv1 --ftp-ssl-reqd --ftp-pasv ftp://${USER}:${PASSWORT}@${FTPADRESSE}:${PORT}/${FTPLOG}
	rm ${LOGOLD} && rm ${LOG}
	LOGCOUNTER=0
	let LOGCOUNTERALL=LOGCOUNTERALL+1
else
### send Logfile to FTP Server
	echo "`date '+%H:%M:%S'` Aktueller Logfile wird an den Sever gesendet." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Ruhezustand wird gestartet." >> ${LOG} 2>&1
	echo "`date '+%H:%M:%S'` Bye Bye!" >> ${LOG} 2>&1
	/mnt/us/usbnet/bin/curl -T ${LOG} -k --ftp-ssl --tlsv1 --ftp-ssl-reqd --ftp-pasv ftp://${USER}:${PASSWORT}@${FTPADRESSE}:${PORT}/${FTPLOG}
fi

### Go into STR
	echo "mem" > /sys/power/state

done
