# Batch script that syncs system clock
I was having some issues with a very old computer that wouldn't show websites because the CMOS battery was dead and the date reset to 1990 every time it rebooted. This caused, among other issues, a problem where websites wouldn't load because their certificate date was in the future.

This script first checks for an internet connection, then gets your IP address from [ipify](https://www.ipify.org/) and uses that in a request to [WorldTimeAPI](http://worldtimeapi.org/) to get the time. It then sets your system clock to this time and triggers a resync to the NTP server at time.google.com. The first step of setting the system clock is required because the system will only resync to a time server if it is off by less than five minutes for security reasons.

This was written in batch so it could run on Windows XP without the need for anything else to be installed. It may be a bit overkill but I set it up to run at startup so my clock is synced if I have an internet connection.

This script relies on winhttpjs.bat which allows an old Windows computer without bitsadmin, wget, curl, or otherwise to save a website's response to a file.