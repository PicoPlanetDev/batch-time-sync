@ECHO OFF
SETLOCAL EnableDelayedExpansion

ping -n 1 -w 1000 -4 google.com | find "TTL"
IF NOT errorlevel 1 GOTO sync
if errorlevel 1 GOTO nointernet

:sync
ECHO Internet connection available. Syncing time.

ECHO Getting IP address
CALL winhttpjs.bat "http://api.ipify.org" -saveTo ip.txt

ECHO Getting first line of IP file
SET /p ipaddress=<ip.txt

ECHO Getting time info
CALL winhttpjs.bat "http://worldtimeapi.org/api/ip/%ipaddress%.txt" -saveTo time.txt

ECHO Getting all of the time info file
FOR /f "Tokens=* Delims=" %%x in (time.txt) DO SET "Time=!Time!%%x"s

ECHO Splitting time info string
SET "string=%Time%"

ECHO Splits the string into fa1 and fa2
SET i=1
SET "fa!i!=%string:datetime: =" & SET /A i+=1 & SET "fa!i!=%"

SET fa

ECHO Uses fa2 and splits off the end
SET j=1
SET "fb!j!=%fa2:day_of_week=" & SET /A j+=1 & SET "fb!j!=%"

SET fb

ECHO Uses fb1 and splits off the T
SET k=1
SET "fc!k!=%fb1:T=" & SET /A k+=1 & SET "fc!k!=%"

SET fc

ECHO fc1 is the date
SET "splitdate=%fc1%"

ECHO Split fc2 by the period
SET l=1
SET "fd!l!=%fc2:.=" & SET /A l+=1 & SET "fd!l!=%"

SET fd

ECHO fd1 is the time
SET "splittime=%fd1%"

ECHO Split splitdate by the hypen so it can be rearranged
SET m=1
SET "fe!m!=%splitdate:-=" & SET /A m+=1 & SET "fe!m!=%"

SET fe

ECHO Rearrange date to (mm-dd-yy)
SET "rearrdate=%fe2%-%fe3%-%fe1%"
ECHO %rearrdate%

date %rearrdate%
time %splittime%

ECHO Now syncing to time server
net start w32time
w32tm /config /syncfromflags:manual /manualpeerlist:time.google.com
w32tm /config /update
w32tm /resync

ECHO Time sync complete
PAUSE
EXIT

:nointernet
ECHO Time sync failed - no internet connection
PAUSE
EXIT