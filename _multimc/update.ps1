Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

$url = 'https://files.multimc.org/downloads/mmc-stable-win32.zip'
$zipDestination = "$PSScriptRoot\tools\mmc-stable-win32.zip"
$unzipDestination = "$PSScriptRoot\unzip"
$executableName = "MultiMC\MultiMC.exe"
$logFile = "MultiMC\MultiMC-0.log"
$versionRegex = '^.*"(\d+\.\d+\.\d+)-.*$'
$infoFile = "$PSScriptRoot\info"

function global:au_SearchReplace {
    @{
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(checksum:).*" = "`${1} $($Latest.Checksum32)"
        }
    }
}

# Not called if there is no update 
function global:au_BeforeUpdate {}

function global:au_GetLatest { # ETags are used to determine a difference of files.
    $updateRequired = $false
    $localInformation = $null
    $liveETag = Get-ETag($url)
    $version = $null
    if (!(Test-Path $infoFile)) {
        Write-Host "No info file for MultiMC. Forcing an update to make one."
        $updateRequired = $true
    } elseif ($global:au_Force -eq $true) {
        Write-Host "Forcing update for MultiMC."
        $updateRequired = $true
    } else {
        $localInformation = Import-HashtableFromSerial $infoFile
        if ($localInformation.ETag -eq $liveETag) {
            Write-Host "The MultiMC live ETag matches the known ETag. No update necessary."
            $updateRequired = $false
        } else {
            Write-Host "The MultiMC live ETag differs from the known ETag. Updating."
            $updateRequired = $true
        }
    }

    if ($updateRequired -eq $false) {
        return $localInformation # There is no update. The info we have is up to date.
    } else {
        # Get the new ZIP
        Remove-Item $zipDestination # For good measure
        Get-WebFile $url $zipDestination | Out-Null

        # Find the version by running it and looking at log
        Get-ChocolateyUnzip -FileFullPath $zipDestination -Destination $unzipDestination
        # This is gross but only way I could find because I cant -v it because
        # all the output from this exe somehow bypasses any sort of redirecting I
        # throw at it.
        Write-Host "Booting MultiMC to sniff version from its log file...`n"
        Write-Host "`n`t==================MultiMC Output==================`n"
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo.FileName = Join-Path $unzipDestination $executableName
        $process.Start()
        $ProcessID = $Process.id
        Start-Sleep -s 10
        Stop-Process -id $ProcessID
        Write-Host "`n`t==================End of MultiMC Output==================`n"

        $logFilePath = Resolve-Path(Join-Path $unzipDestination $logFile)
        if (Test-Path -Path $logFilePath) {
            $version = (Get-Content $logFilePath)[2] -replace $versionRegex, '$1'
            if ($null -eq $version) {
                Write-Error "There was an error fetching the MultiMC version from the log file."
            } else {
                Write-Host "Version was: $version"
            }

            # Cleanup and Write info file
            Remove-Item -Path $unzipDestination -Recurse -Force
            Export-HashtableToSerial @{ETag = $liveETag;Version = $version} $infoFile
        } else {
            Write-Error "Could not find log file to read MultiMC version from."
        }

        return @{
            ETag = $liveETag
            Version = $version
        }
    }
    
}

update -ChecksumFor none
