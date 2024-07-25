$ErrorActionPreference = 'Stop'; # stop on all errors

# Fail install if on an unsupported platform
if (!(Get-OSArchitectureWidth -Compare 64) -or !($env:OS_NAME -eq "Windows 10" -or $env:OS_NAME -eq "Windows 11")) {
  throw "WPILib requires Windows 10 64-bit version or newer. Aborting installation."
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url             = 'https://github.com/wpilibsuite/allwpilib/releases/download/v2023.1.1/WPILib_Windows-2023.1.1.iso'
$isoChecksum     = '5094459bbe2bbe91fa6e21b85d424435bf6ceacea24dae0b441fa4694f941015'
$installerName   = 'WPILibInstaller.exe'
$ahkInstalScript = 'WPILibInstall.ahk'

# Get Package Parameters and set defaults
$pp = Get-PackageParameters
$ahkParameters = New-Object Collections.Generic.List[string]
$ahkParameters.Add($(Join-Path -Path $toolsDir -ChildPath $ahkInstalScript))
$ahkParameters.Add($(if($pp.InstallScope) {$pp.InstallScope} else {"allUsers"}))
$ahkParameters.Add($(if($pp.VSCodeZipPath) {$pp.VSCodeZipPath} else {"download"}))
$ahkParameters.Add($(if($pp.AllowUserInteraction) {$pp.AllowUserInteraction} else {"false"}))

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  softwareName = 'WPILib*'
  fileType     = 'EXE'
  checksumType = 'sha256'
  Url          = $url
  file         = $installerName
  checksum     = $isoChecksum
  silentArgs   = '' #none
}

Write-Debug "Running AutoHotKey.exe with parameters: $ahkParameters"
$ahkProc = Start-Process -FilePath 'AutoHotKey.exe' -ArgumentList $ahkParameters
$ahkId = $ahkProc.Id
Write-Debug "AHK start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyIsoPackage @packageArgs #https://docs.chocolatey.org/en-us/guides/create/mount-an-iso-in-chocolatey-package