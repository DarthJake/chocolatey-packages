$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://github.com/REVrobotics/REV-Software-Binaries/releases/download/rhc-1.4.3/REV-Hardware-Client-Setup-1.4.3.exe'
$fileName = 'REV-Hardware-Client-Setup-1.4.3.exe'
$checksum = 'a02918fa1da7e8c76431c8d7adb042b086c7456afad8dcf127c44cf7af91a2e6'

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
