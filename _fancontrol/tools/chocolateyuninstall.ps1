$ErrorActionPreference = 'Stop'; # stop on all errors

$processName = "FanControl"

try {
  Write-Debug "Attempting to stop the $processName process..."
  Stop-Process -Name $processName -Force
} catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
  Write-Debug "Unable to stop the $processName process. Perhaps it is stopped."
}