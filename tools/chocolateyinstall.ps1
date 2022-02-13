$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = "https://firstfrc.blob.core.windows.net/frc2022/Radio/FRC_Radio_Configuration_22_0_1.zip"
$fileName = "FRC_Radio_Configuration_22_0_1.exe"
$zipChecksum = 'C49EA376122EA6CAA38264F333292D61057D89AE29DE15EA99937DF799ADB1E3'
$exeChecksum = '12221ED6E633302D689A8FEAD6C3E07266B5AD3785820F9C2F536B50A2189B57'

$unzipPackageArgs = @{
  packageName   = $env:ChocolateyPackageName
  Url           = $url
  checksum      = $zipChecksum
  checksumType   = 'sha256'
  UnzipLocation = $toolsDir
}
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'FRC Radio Configuration Utility*'
  fileType       = 'EXE'
  file           = "$toolsDir\$fileName"
  checksum       = $exeChecksum
  checksumType   = 'sha256'
  silentArgs     = '/SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /RESTARTEXITCODE=3010'
  validExitCodes = @(0, 3010)
}

Install-ChocolateyZipPackage  @unzipPackageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage.

$ahkExe = "AutoHotKey" # This is a reference to the global AHK exe
$ahkFile = Join-Path $toolsDir "FRCRadioConfigUtilityInstall.ahk"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkFile`"" -Verb RunAs -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyInstallPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateyinstallpackage