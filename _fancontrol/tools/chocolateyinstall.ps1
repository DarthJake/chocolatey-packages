$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
`
$url        = 'https://github.com/Rem0o/FanControl.Releases/archive/refs/tags/V110.zip'
$checksum   = '27E9AF1C92B88C60B85245513DDD3F587F0AC41E55910E6DF46C8957291FF9EC'
$folderName = 'FanControl.Releases-110'

$unzipPackageArgs = @{
  packageName    = $env:ChocolateyPackageName
  Url            = $url
  checksum       = $checksum
  checksumType   = 'sha256'
  SpecificFolder = "$folderName\FanControl.zip"
  UnzipLocation  = $toolsDir
}

Install-ChocolateyZipPackage @unzipPackageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage.

Get-ChocolateyUnzip `
  -FileFullPath (Join-Path $toolsDir "$folderName\FanControl.zip") `
  -Destination $toolsDir

# Remove unzipped folder
Remove-Item -Path (Join-Path $toolsDir $folderName) -Recurse -Force