Import-Module au
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

# $domain = 'https://firstfrc.blob.core.windows.net'
# $releases = "$domain/CrossTheRoadElec/Phoenix-Releases/releases"
$releases = "https://cdn.jsdelivr.net/gh/wpilibsuite/frc-docs@stable/source/docs/zero-to-robot/step-3/radio-programming.rst"

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*[$]fileName\s*=\s*)('.*')" = "`$1'$($Latest.ExeName)'"
            "(?i)(^\s*[$]zipChecksum\s*=\s*)('.*')" = "`$1'$($Latest.ZipChecksum)'"
            "(?i)(^\s*[$]exeChecksum\s*=\s*)('.*')" = "`$1'$($Latest.ExeChecksum)'"
        }
    }
}

# Not called if there is no update
function global:au_BeforeUpdate {
    # Make temp path to download and extract exe to get checksums
    $tempPath = "./temp"
    Write-Verbose "Creating temporary path: $tempPath"
    New-Item -ItemType Directory -Path $tempPath | Out-Null
    $tempPath = Resolve-Path $tempPath
    
    try {
        $checksumType = 'sha256'

        # Get Zip Checksum
        Write-Verbose "Downloading $Latest.url"
        $destZip = Join-Path $tempPath $Latest.ZipName
        Invoke-WebRequest -Uri $Latest.url -OutFile $destZip -UseBasicParsing
        $Latest.ZipChecksum = Get-FileHash -Path $destZip -Algorithm $checksumType | ForEach-Object { $_.Hash.ToLowerInvariant() }

        # Get Exe Checksum
        Write-Verbose "Unzipping $destZip"
        Expand-Archive -Path $destZip -DestinationPath $tempPath
        $destExe = Join-Path $tempPath $Latest.ExeName
        $Latest.ExeChecksum = Get-FileHash -Path $destExe -Algorithm $checksumType | ForEach-Object { $_.Hash.ToLowerInvariant() }
    }
    finally {
        Write-Verbose "Removing temporary path: $tempPath"
        Remove-Item -Path $tempPath -Recurse -Force
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # Determine URL, FileName, and Version
    $Matches = $null
    $regex = "(?:<)(?<URL>https:\/\/firstfrc.blob.core.windows.net\/frc\d{4}\/Radio\/(?<FileName>FRC_Radio_Configuration_(?<Version>.*)\.zip))(?:>)"
    $download_page.RawContent | ForEach-Object {$_ -match $regex} | Out-Null
    $url = $Matches.URL
    $fileName = $Matches.FileName
    $version = $Matches.Version -replace "_", "."

    return @{
        URL = $url
        Version = $version
        ZipName = $fileName
        ExeName = $fileName -replace ".zip", ".exe"
    }
}

update -ChecksumFor none
