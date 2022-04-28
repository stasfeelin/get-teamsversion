$TeamsExe = Get-Item ("${Env:LOCALAPPDATA}" + "\Microsoft\Teams\current\Teams.exe")
$LogFile = $env:APPDATA + "\Microsoft\Teams\logs.txt"
$InstallTimeFile = $env:APPDATA + "\Microsoft\Teams\installTime.txt"

$TeamsVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($TeamsExe)

$ClientVersion = Get-Content $LogFile | Where-Object { $_.Contains("Client version") }
if ( $ClientVersion.GetType().Name -eq "Object[]" ) { $ClientVersion = $ClientVersion[-1] }
$ClientVersion = $($ClientVersion) -split "is: "

$slimcoreInfo = (Get-Content $LogFile | Where-Object {$_.Contains("slimcore version:")}) -split ": "

$InstallDate = Get-Content $InstallTimeFile
$ringInfo = Get-Content $LogFile | Where-Object { $_.Contains("ring=") -and $_.Contains("-- info --") }
$ring = $($ringInfo[-1]) -split "ring"
$UpdateCheckDate = $($ringInfo[-1]) -split "<"
$TeamsVersion
Write-Host ""
If ($ring[2] -ne $null)
{
    write-host "Ring: $($ring[2].Replace("_","."))"
}
else
{
    write-host "Ring is GA"
}

Write-host "Install Date: $($InstallDate)`n"
Write-Host "Last Update Check: $($UpdateCheckDate[0])`n"
Write-Output "Clientversion: $($ClientVersion[-1])`n"
Write-Host "Slimcore version: $($slimcoreInfo[-1])`n"
