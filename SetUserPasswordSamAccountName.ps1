# Warning, make sure to restrict rights at the Active Directory level to use this script properly

$sAMAccountName=$args[0]
$newPasswordIn=$args[1]

Set-ADAccountPassword -Identity $sAMAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPasswordIn" -Force)

$theResult=Get-ADUser -properties PasswordLastSet  -Identity $sAMAccountName | Select-Object PasswordLastSet -ExpandProperty PasswordLastSet
 Write-Output "------------------------------------------------------------------------------"
 Write-Output ""
 Write-Output "Password Reset for User: $sAMAccountName on ${theResult}"
 Write-Output ""
 Write-Output "------------------------------------------------------------------------------"
 