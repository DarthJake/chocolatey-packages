import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = "https://www.ni.com/en-us/support/downloads/drivers/download.frc-game-tools.html"

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.checksum)'"
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
        Invoke-WebRequest -Uri $Latest.url -OutFile $destZip
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
    $download_page = Invoke-WebRequest -Uri $releases

    # Determine URL, FileName, and Version
    $regex = "`"includedversions-downloadpath`":`"(?<URL>https:\/\/download\.ni\.com\/support\/nipkg\/products\/ni-f\/ni-frc-\d{4}-game-tools\/[0-9.]*\/offline\/ni-frc-\d{4}-game-tools_(?<Version>\d+\.\d+\.\d+)_offline.iso).*?\(SHA256\)<\/b>\s*(?<Checksum>[0-9a-fA-F]{64})"
    # We need to find the biggest one and save the whole match to extract everything from the newest match
    $m = $download_page.Content | Select-String -Pattern $regex -AllMatches | ForEach-Object {$_.Matches} # Get the list of matches
    $url = $m | ForEach-Object {$_.Groups[1].Value} | Sort-Object -Descending | Select-Object -First 1
    $version = $m | ForEach-Object {$_.Groups[2].Value} | Sort-Object -Descending | Select-Object -First 1

    return @{
        URL = $url
        Version = $version
    }
}

update -ChecksumFor none
