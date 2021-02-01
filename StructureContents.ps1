# Parse content of an input file and insert into an object which, output to CSV
# Author Tay Kratzer tay@cimitra.com

Param(
    [string] $inputFile,
    [string] $formatType
)


 ##VVVVVVV-MAKE CHANGES-VVVVVVVV##

 # How many lines to skip in the input file
$inputFileSkipLines = 2

# Make the 5 field headers more user friendly
$fieldOneHeader = "ID"
$fieldTwoHeader = "User Name"
$fieldThreeHeader = "Year"
$fieldFourHeader = "Term"
$fieldFiveHeader = "Status"
$blankSpace = " "

##^^^^^^^^-MAKE CHANGES-^^^^^^^^##

###### INFORMATION ######
#-------------------------
# Example content for the input file this script was developed with
#people_code_id	username                                          	year	term          	status
#--------------	--------------------------------------------------	----	--------------	------
#P000019145    	smithb                                     2005	SPRING        	ENRL  
#P000019145    	smithb                                            	2002	        FALL          	ENRL  
#P000019145    	smithb         2002	SUMMER        	ENRL  
#P000019145    	smithb                                            	2002	SPRING        	     ENRL  
#P000019145    	smithb      
#--------------------------


# This is where the real coding begings

# Determine if the inputFile was specified (required paramter)
$inputIn = [string]::IsNullOrWhiteSpace($inputFile)

# Determine if the output format was specified (optional parmeter)
$formatIn = [string]::IsNullOrWhiteSpace($formatType)

# Determine script name for the Help function
$ScriptName = $MyInvocation.MyCommand.Name

# Help function
function Help(){
Write-Output ""
Write-Output "Script Help"
Write-Output ""
Write-Output "Syntax: $ScriptName -inputFile <file with unstructured data> -formatType <text|csv>"
Write-Output ""
exit 0
}

# If the -inputIn parameter isn't used, show the Help screen
if($inputIn){
Help
}


$temporaryFile = New-TemporaryFile

function STRUCTURE_INPUT_FILE{

# If file $theFileExternal exists, the run this function
if(Test-Path $inputFile -PathType Leaf){

$counterOne = 0

$ouputObject = New-Object -TypeName PSCustomObject

$ouputObject = foreach($line in [System.IO.File]::ReadLines("$inputFile"))
{


       $counterOne++
       if($counterOne -eq 1){

            $ObjectProperties = @{
            fieldOne = $fieldOneHeader
            fieldTwo = $fieldTwoHeader
            fieldThree= $fieldThreeHeader
            fieldFour = $fieldFourHeader
            fieldFive = $fieldFiveHeader
        }
        
New-Object PSCustomObject -Property $ObjectProperties


       }
       # Skip the first two lines
       if($counterOne -gt $inputFileSkipLines){
       # The data in the example input file had the first two lines that I wanted to discard

       # Read in each line, and remove whitespace
       $line = $line.Trim()
       # Get the first field and assign it to a variable
       $fieldOne = $line -replace '\s{1,}', ' ' | %{ $_.Split(' ')[0]; } 
       # Get the second field and assign it to a variable
       $fieldTwo = $line -replace '\s{1,}', ' ' | %{ $_.Split(' ')[1]; } 
       # Get the third field and assign it to a variable
       $fieldThree = $line -replace '\s{1,}', ' ' | %{ $_.Split(' ')[2]; } 
       # Get the fourth field and assign it to a variable
       $fieldFour = $line -replace '\s{1,}', ' ' | %{ $_.Split(' ')[3]; } 
       # Get the fifth field and assign it to a variable
       $fieldFive = $line -replace '\s{1,}', ' ' | %{ $_.Split(' ')[4]; } 
 
            # Push the current line's fields into the OutputObject object
            #-----------------------------------------------------------#
            $ObjectProperties = @{
            fieldOne = $fieldOne
            fieldTwo = $fieldTwo
            fieldThree= $fieldThree
            fieldFour = $fieldFour
            fieldFive = $fieldFive
        }
        
            New-Object PSCustomObject -Property $ObjectProperties
            #-----------------------------------------------------------#
}

      
}


}

# Output each object in the outputObject, skip the headers


if($formatType -eq "csv")
{
$ouputObject | Export-Csv -Path $temporaryFile -NoTypeInformation
#Remove the first line of the CSV it has PowerShell object material that's not needed
get-content $temporaryFile | select-object -skip 1
Remove-Item $temporaryFile
}else{
$ouputObject | Format-Table -HideTableHeaders fieldOne,fieldTwo,fieldThree,fieldFour,fieldFive
}

}

STRUCTURE_INPUT_FILE