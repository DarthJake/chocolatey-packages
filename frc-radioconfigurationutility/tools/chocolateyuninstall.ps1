$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$uninstallerLocation = Join-Path ${Env:ProgramFiles(x86)} "FRC Radio Configuration Utility\unins000.exe"

$packageArgs = @{
  PackageName   = $env:ChocolateyPackageName
  FileType      = 'EXE'
  silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART"
  File          = $uninstallerLocation
  ValidExitCodes= @(0, 3010)
}

Write-Host "`nRunning the FRC Radio Configuration Utility AHK uninstaller script..."
$ahkExe = "AutoHotKey" # This is a reference to the global AHK exe
$ahkFile = Join-Path $toolsDir "FRCRadioConfigUtilityUninstall.ahk"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkFile`"" -Verb RunAs -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Uninstall-ChocolateyPackage  @packageArgs
Write-Host "`nUninstall attempt complete.`nWaiting for NPCap to finish uninstalling..."

# Wait for the ahk process to end before moving on
Wait-Process -Name "AutoHotkey" -Timeout 180