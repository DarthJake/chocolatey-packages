$ErrorActionPreference = 'Stop'; # stop on all errors

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'CTRE Phoenix Framework*'  #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  fileType      = 'EXE'
  silentArgs   = '/S' # NSIS
  validExitCodes= @(0) #please insert other valid exit codes here
}

Uninstall-ChocolateyPackage @packageArgs