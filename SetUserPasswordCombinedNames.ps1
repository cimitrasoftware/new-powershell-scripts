# Change the context variable to match your system
# -------------------------------------------------

$context = "OU=USERS,OU=DEMO,OU=CIMITRA,DC=cimitrademo,DC=com" 

# -------------------------------------------------
# Get the first command-line variable
$firstNameIn=$args[0]
# Make sure the first character is uppercased
$firstNameIn = (Get-Culture).TextInfo.ToTitleCase($firstNameIn)
# Get the second command-line variable
$lastNameIn=$args[1]
# Make sure the first character is uppercased
$lastNameIn = (Get-Culture).TextInfo.ToTitleCase($lastNameIn)
# Make the samAccountName variable from a combination of the user's first and last name
$samAccountName = ($firstNameIn+$lastNameIn).ToLower()
# Default password
$newPasswordIn=$args[2]

Set-ADAccountPassword -Identity "CN=${firstNameIn} ${lastNameIn},$context" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPasswordIn" -Force)

$theResult=Get-ADUser -properties PasswordLastSet  -Identity "CN=${firstNameIn} ${lastNameIn},$context" | Select-Object PasswordLastSet -ExpandProperty PasswordLastSet
 
 Write-Output "------------------------------------------------------------------------------"
 Write-Output ""
 Write-Output "Password Reset for User: ${firstNameIn} ${lastNameIn} on ${theResult}"
 Write-Output ""
 Write-Output "------------------------------------------------------------------------------"
