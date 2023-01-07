$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url         = 'https://github.com/wpilibsuite/allwpilib/releases/download/v2023.1.1/WPILib_Windows-2023.1.1.iso'
$fileName    = 'WPILibInstaller.exe'
$isoChecksum = '5094459bbe2bbe91fa6e21b85d424435bf6ceacea24dae0b441fa4694f941015'

$pp = Get-PackageParameters
$ahkParameters = ""
$ahkParameters += if ($pp.InstallScope) { "`"$($pp.InstallScope)`"" }
$ahkParameters += if ($pp.VSCodeZipPath) { " $($pp.VSCodeZipPath)" }
$ahkParameters += if ($pp.AllowUserInteraction) { " $($pp.AllowUserInteraction)" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'WPILib*'
  fileType       = 'EXE'
  checksumType   = 'sha256'
  Url            = $url
  file           = $fileName
  checksum       = $isoChecksum
  silentArgs     = '' #none
}

if (!(Get-OSArchitectureWidth -Compare 64) -or !($env:OS_NAME -eq "Windows 10" -or $env:OS_NAME -eq "Windows 11")) {
  throw "WPILib requires Windows 10 64-bit version or newer. Aborting installation."
}

$ahkExe = "AutoHotKey" # This is a reference to the global AHK exe
$ahkFile = Join-Path $toolsDir "WPILibInstall.ahk"
Write-Debug "Running: $ahkExe `"$ahkFile`"$ahkParameters"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkFile`" $ahkParameters" -Verb RunAs -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyIsoPackage @packageArgs #https://docs.chocolatey.org/en-us/guides/create/mount-an-iso-in-chocolatey-package