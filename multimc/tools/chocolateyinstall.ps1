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

# Set permissions so MultiMC can write its files
$mmcPath = Join-Path $toolsDir 'MultiMC'
$Acl = Get-Acl $mmcPath
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl $mmcPath $Acl

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