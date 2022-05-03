$ErrorActionPreference = 'Stop'; # stop on all errors

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'REV Hardware Client*'
  fileType      = 'EXE'
  silentArgs   = '/S' # NSIS
  validExitCodes= @(0) 
}

Uninstall-ChocolateyPackage @packageArgs