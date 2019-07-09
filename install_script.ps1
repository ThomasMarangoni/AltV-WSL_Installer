$debug = $TRUE
$version = [System.Environment]::OSVersion.Version
if($version.Major -ne 10)
{
	Write-Host -ForegroundColor Red "ERROR - WINDOWS: Windows 10 is required.`n"
	pause
	exit
}
$release = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
if($release -lt 1903)
{
	Write-Host -ForegroundColor Red "ERROR - RELEASE: Windows 10 Build 1903 or higher is required."
	Write-Host -ForegroundColor Yellow "Used Build is $release.`n"
	pause
	exit
}

$admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if(!$admin)
{
	Write-Host -ForegroundColor Red "ERROR - PERMISSION: run the script with higher permission again.`n"
	pause
	exit
}

# Enable Developer Mode
Write-Host "`nINFO: Developer Mode will be enabled, you have to disable it manually later.`n"
$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (-not(Test-Path -Path $RegistryKeyPath)) {
	New-Item -Path $RegistryKeyPath -ItemType Directory -Force
}

# Add registry value to enable Developer Mode
New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force | out-null

$results = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
if(![bool]$results.State)
{
	Write-Host -ForegroundColor Magenta "Windows Subsystem for Linux not found, restart required.`nIf you continue the WSL will be installed and the computer will be rebooted, after reboot you have to start the script again.`n"
	
	$msg = 'Do you want to install the WSL and restart the computer? [Y/N]'
	$response = Read-Host -Prompt $msg
	if ($response -ne 'y')
	{
        exit
    }
	
	Write-Host "Starting installing process.`n"
	$results = Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart -WarningAction SilentlyContinue
	if ($results.RestartNeeded -eq $true) {
	  Restart-Computer -Force
	}
	exit
	
}
Write-Host -ForegroundColor Green "Windows Subsystem for Linux found, no restart required.`n"
New-Item -ItemType Directory -Force -Path tmp | out-null
cd tmp
Write-Host "INFO: Downloading Debian for WSL.`n"
curl.exe -sLo debian.appx https://aka.ms/wsl-debian-gnulinux
cd ..
Add-AppxPackage -Volume C:\ tmp\debian.appx

Write-Host -ForegroundColor Magenta "`nPlease enter a username and a password in the new window.`nAfter initialization is finished, close the window."
Write-Host "INFO: The password wont be shown when you are typing, but it will be entered.`n"
start debian.exe

$debian = Get-Process Debian -ErrorAction SilentlyContinue
while ($debian) {
	$debian = Get-Process Debian -ErrorAction SilentlyContinue
}

wsl -s Debian

Write-Host -ForegroundColor Magenta "Please enter your selected password when asked."
Write-Host "INFO: The password wont be shown when you are typing, but it will be entered.`n"
wsl -e sudo sh data/bash_init.sh

Write-Host -ForegroundColor Magenta "`nPlease enter your selected password when asked."
Write-Host "INFO: The password wont be shown when you are typing, but it will be entered.`n"
wsl -e sh data/bash_download_server.sh

Copy-Item -Path "data\scripts" -Recurse -Destination "c:\altv-server\" -Container
Copy-Item -Path "data\server.cfg" -Destination "c:\altv-server\server.cfg"

Remove-Item -Force -Recurse tmp

ii c:\altv-server\scripts

Write-Host -ForegroundColor Green "`nInstallation finished.`n"
pause