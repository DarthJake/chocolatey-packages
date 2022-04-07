$ErrorActionPreference = 'Stop'; # stop on all errors
# Note: Install programming environments such as NI LabVIEW or Microsoft Visual Studio before installing this product.

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = "https://download.ni.com/support/nipkg/products/ni-f/ni-frc-2022-game-tools/22.0/offline/ni-frc-2022-game-tools_22.0.1_offline.iso"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'NISoftware*'
  fileType       = 'EXE'
  Url            = $url
  file           = 'Install.exe'
  checksum       = '62401e5ff6ec71c4c3e70f2a239ae312b1b471ee6da6c1a715218b4522161812'
  checksumType   = 'sha256'
  silentArgs     = '--passive --accept-eulas --prevent-reboot --prevent-activation'
  validExitCodes = @(0, -125071, -126300)
}

if (!(Get-OSArchitectureWidth -Compare 64) -or !($env:OS_NAME -eq "Windows 10" -or $env:OS_NAME -eq "Windows 11")) {
  throw "NI FRC Game Tools requires Windows 10 64-bit version or newer. Aborting installation."
}

Install-ChocolateyIsoPackage @packageArgs #https://docs.chocolatey.org/en-us/guides/create/mount-an-iso-in-chocolatey-package