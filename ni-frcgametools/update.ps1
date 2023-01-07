Import-Module au
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

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
function global:au_BeforeUpdate {}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # Determine URL, Version, and Checksum
    $regex = "`"includedversions-downloadpath`":`"(?<URL>https:\/\/download\.ni\.com\/support\/nipkg\/products\/ni-f\/ni-frc-\d{4}-game-tools\/[0-9.]*\/offline\/ni-frc-\d{4}-game-tools_(?<Version>\d+\.\d+\.\d+)_offline.iso).*?\(SHA256\)<\/b>\s*(?<Checksum>[0-9a-fA-F]{64})"
    # Get the largest match by version
    $current = $download_page.Content | Select-String -Pattern $regex -AllMatches |`
        ForEach-Object {$_.Matches} | Sort-Object -Property Groups["Version"].Value -Descending |`
        Select-Object -First 1 
    $url = $current.groups["URL"].Value
    $version = $current.groups["Version"].Value
    $checksum = $current.groups["Checksum"].Value   

    return @{
        URL = $url
        Version = $version
        Checksum = $checksum
    }
}

update -ChecksumFor none
