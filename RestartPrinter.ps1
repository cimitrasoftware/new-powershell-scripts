# Cimitra Print Spooler Restart Script
# Version 1.0
# Release Date: 9/18/2020
# Author: Tay Kratzer tay@cimitra.com
# ---------------------------------------

### MODIFY THESE THREE VALUES TO USE SCRIPT FOR OTHER WINDOWS SERVICES ###

###VARIABLES BEGIN###

$PROCESS_IN = "spoolsv"

$SERVICE_NAME = "Spooler"

$SERVICE_FRIENDLY_NAME = "Print Server"

###VARIABLES END###

# Make a temporary file
$TEMP_FILE=New-TemporaryFile

# Find the process spool service (spoolsv) and format output as a list (fl)
Get-Process ${PROCESS_IN}* | fl 1> $TEMP_FILE

# Get just the line that has the word "Id" in it
$PID_LINE = Select-String -Path $TEMP_FILE -Pattern "Id"

# Remove the Temp file
Remove-Item -Path $TEMP_FILE -Force

# Remove all spaces in the line (easier for parsing accurately with the next comand)
$PID_LINE = $PID_LINE -replace " ", ""


# Get the first set column of data after the text "Id:", which is the process PID
$PROCESS_PID = ($PID_LINE -split "Id:")[1]
Write-Output ""
Write-Output "====================================="
Write-Output "Current ${SERVICE_FRIENDLY_NAME} Process ID:      [ $PROCESS_PID ]"
Write-Output "====================================="
Write-Output "Restarting $SERVICE_FRIENDLY_NAME"

# Restart the Print Spooler Process
Restart-Service -Name ${SERVICE_NAME} -Force

# Get the PID again to confirm help to visually confirm that the process was restarted

# Make a temporary file
$TEMP_FILE=New-TemporaryFile

# Find the process spool service (spoolsv) and format output as a list (fl)
Get-Process ${PROCESS_IN}* | fl 1> $TEMP_FILE

# Get just the line that has the word "Id" in it
$PID_LINE = Select-String -Path $TEMP_FILE -Pattern "Id"

# Remove the Temp file
Remove-Item -Path $TEMP_FILE -Force

# Remove all spaces in the line (easier for parsing accurately with the next comand)
$PID_LINE = $PID_LINE -replace " ", ""


# Get the first set column of data after the text "Id:", which is the process PID
$PROCESS_PID = ($PID_LINE -split "Id:")[1]

Write-Output "====================================="
Write-Output "Restarted ${SERVICE_FRIENDLY_NAME} Process ID:  [ $PROCESS_PID ]"
Write-Output "====================================="
