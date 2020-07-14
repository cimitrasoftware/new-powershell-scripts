$outPutFile = "c:\temp\WriteMessageOutput.txt"
Remove-Item $outPutFile
Write-Output "$args " | Write-Host -NoNewline 6>> $outPutFile 
Write-Output ""
Write-Output "[ Your Message is Below ]"
Write-Output ""
Get-Content $outPutFile

Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$tts = New-Object System.Speech.Synthesis.SpeechSynthesizer
$PhraseLocation = $outPutFile
$Phrase         = (Get-Content $PhraseLocation) 
$tts.Speak($Phrase)
Write-Output ""
Write-Output "[ Message Delievered! ]"