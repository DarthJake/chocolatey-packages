$ErrorActionPreference = 'Stop'; # stop on all errors
# Note: Install programming environments such as NI LabVIEW or Microsoft Visual Studio before installing this product.

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.ni.com/support/nipkg/products/ni-f/ni-frc-2023-game-tools/23.0/offline/ni-frc-2023-game-tools_23.0.0_offline.iso'
$checksum = 'b90526045b107eef5449b35037d5fb26e76e70802b29d90c902a25f2b055d449'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'NISoftware*'
  fileType       = 'EXE'
  Url            = $url
  file           = 'Install.exe'
  checksum       = $checksum
  checksumType   = 'sha256'
  silentArgs     = '--passive --accept-eulas --prevent-reboot --prevent-activation'
  validExitCodes = @(0, -125071, -126300)
}

if (!(Get-OSArchitectureWidth -Compare 64) -or !($env:OS_NAME -eq "Windows 10" -or $env:OS_NAME -eq "Windows 11")) {
  throw "NI FRC Game Tools requires Windows 10 64-bit version or newer. Aborting installation."
}

Install-ChocolateyIsoPackage @packageArgs #https://docs.chocolatey.org/en-us/guides/create/mount-an-iso-in-chocolatey-package
