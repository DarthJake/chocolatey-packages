$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url      = 'https://github.com/REVrobotics/REV-Software-Binaries/releases/download/rhc-1.4.2/REV-Hardware-Client-Setup-1.4.2.exe'
$fileName = 'REV-Hardware-Client-Setup-1.4.2.exe'
$checksum = '3079682280D7735FE1399B970EE321E67FDA4087745D04DD55B4F3ABE70FC33C'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'REV Hardware Client*'
  fileType       = 'EXE'
  Url            = $url
  file           = $fileName
  checksum       = $checksum
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

$ahkExe = "AutoHotKey" # This is a reference to the global AHK exe
$ahkFile = Join-Path $toolsDir "rev-hardwareclientInstall.ahk"
Write-Debug "Running: $ahkExe `"$ahkFile`"$ahkParameters"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkFile`" $ahkParameters" -Verb RunAs -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage  @packageArgs