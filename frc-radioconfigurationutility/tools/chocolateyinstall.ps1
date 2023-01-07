$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://firstfrc.blob.core.windows.net/frc2023/Radio/FRC_Radio_Configuration_23_0_2.zip'
$fileName = 'FRC_Radio_Configuration_23_0_2.exe'
$zipChecksum = 'be0ae0ce0e60d9ef5467b0a2e91695cb2238713fea92f9fa4ee5c14cb8162365'
$exeChecksum = 'e0727c8fc99175af128d0fc5f47db4e000acc17f74ad600635e15abf880c9a45'

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
