$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = "https://firstfrc.blob.core.windows.net/frc2020/Radio/FRC_Radio_Configuration_20_0_0.zip"
$fileName = "FRC_Radio_Configuration_20_0_0.exe"
$zipChecksum = 'B37CD7746FB9D380C4ABD1261D7F3A5B2C50F2FCF4FC5E55E460FEB7CF76CFD8'
$exeChecksum = '30D3CD4780AB9C6E861A40CFDC8C9AE074937536EF6112DC938BB6D198B6FCDF'

$unzipPackageArgs = @{
  packageName   = $env:ChocolateyPackageName
  Url           = $url
  checksum      = $zipChecksum
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