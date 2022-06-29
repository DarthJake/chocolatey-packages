$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Choco sometimes fails being unable to delete this
Remove-Item (Join-Path $toolsDir 'MultiMC') -Force -Recurse