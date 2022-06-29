$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$fileName = 'mmc-stable-win32.zip'
$pp = Get-PackageParameters

$unzipArgs = @{
  FileFullPath = Join-Path $toolsDir $fileName
  Destination  = Join-Path $toolsDir
  PackageName  = $env:ChocolateyPackageName
}

Get-ChocolateyUnzip @unzipArgs

if (!$pp.NoStartMenu) {
  Write-Host "Creating Start Menu shortcut..."
  $startmenu = Join-Path $env:programdata "Microsoft\Windows\Start Menu\Programs"
  Install-ChocolateyShortcut -ShortcutFilePath $(Join-Path $startmenu "MultiMC.lnk") -TargetPath $(Join-Path $toolsDir "MultiMC\MultiMC.exe")
}

if (!$pp.NoDesktopIcon) {
  Write-Host "Creating Desktop shortcut..."
  $desktop = [Environment]::GetFolderPath("Desktop")
  Install-ChocolateyShortcut -ShortcutFilePath $(Join-Path $desktop "MultiMC.lnk") -TargetPath $(Join-Path $toolsDir "MultiMC\MultiMC.exe")
}