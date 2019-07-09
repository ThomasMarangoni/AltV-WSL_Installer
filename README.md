# AltV-WSL Installer
This script will activate the Windows Subsystem for Linux (not WSL2 yet) on your computer, installs debian and setting up a alt:V Server.

## Minimun Requirements
- Windows 10 - Build 1903

## How to run the Installer?
- download this repo as .zip file or clone it
- unpack it (if downloaded as .zip)
- run the "start_installer.bat" as normal user
- allow admin priviliges
- follow instructions

## Hints
- When Debian opens in a separated window, enter a username and two times your password. After that close the window.
- In Linux and WSL you aren't able to see your password when typing.
- A unix username follows this regex \[a-z_]\[a-z0-9_-]*
  - all letters are lower case
  - the first position must be a-z or _
  - other positions can be a-z, 0-9 or _
- Server folder can be found:
  - Windows: C:\altv-server\
  - Linux: ~/altv-server/ or /mnt/c/altv-server/
- WSL can be accessed:
  - "Debian" in programms
  - wsl in powershell/cmd
  - bash in powershell/cmd
