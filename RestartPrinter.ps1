# Restart The Local Windows Print Spooler (Tested in Windows 10)
# Author: Tay Kratzer tay@cimitra.com
# -------------------------------------------------
$SpoolerPIDRaw = cmd /c sc queryex spooler | findstr PID
$SpoolerPID = $SpoolerPIDRaw -split ': '  | select -skip 1
Write-Output "================================================="
Write-Output "Current Print Server Process ID: [ $SpoolerPID ]"
Write-Output "================================================="
Write-Output "Restarting Print Server"
Restart-Service -Name Spooler -Force
$SpoolerPIDRaw = cmd /c sc queryex spooler | findstr PID
$SpoolerPID = $SpoolerPIDRaw -split ': '  | select -skip 1
Write-Output "================================================="
Write-Output "New Print Server Process ID:     [ $SpoolerPID ]"
Write-Output "================================================="


