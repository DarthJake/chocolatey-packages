$ErrorActionPreference = 'Stop'; # stop on all errors

# The directory for the ni unistaller exe is stored in a reg key
$uninstallerLocation = Join-Path (Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\WOW6432Node\National Instruments\Common\Installer\MIF\MetaUninstaller' -Name 'Path') "uninst.exe"
$systemDriveLetter = (Get-WmiObject Win32_OperatingSystem).getPropertyValue("SystemDrive")
$niProgramDataLocation = Join-Path $systemDriveLetter "\ProgramData\National Instruments"

$packageArgs = @{
  PackageName    = $env:ChocolateyPackageName
  FileType       = "exe"
  SilentArgs     = "/qb /x all"
  File           = $uninstallerLocation
  validExitCodes = @(0, 3010)
}

Write-Host "`nUninstalling NI FRC Game Tools"
Write-Host "`n`tRunning the NI uninstaller..."
Uninstall-ChocolateyPackage  @packageArgs

Write-Host "`n`tRemoving the NI ProgramData folder..." #The uninstaller does not remove this
if (Test-Path -Path $niProgramDataLocation) {
  Remove-Item $niProgramDataLocation -ErrorAction SilentlyContinue -Force -Recurse
  
  if (!(Test-Path -Path $niProgramDataLocation)) {
    Write-Host "`n`t`tRemoved the NI ProgramData folder at `"$niProgramDataLocation`"" -ForegroundColor Green
  } else {
    Write-Host "`n`t`tAn error occured while trying to delete the NI ProgramData folder at `"$niProgramDataLocation`"" -ForegroundColor Red
  }
} else {
  Write-Host "It appears that the NI ProgramData folder expected at `"$niProgramDataLocation`" does not exists. This could either mean NI was never installed or the uninstaller removed it like it should, but doesn't." -ForegroundColor Yellow
}