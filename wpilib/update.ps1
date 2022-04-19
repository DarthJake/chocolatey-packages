import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$domain = 'https://github.com'
$releases = "$domain/wpilibsuite/allwpilib/releases"

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url32\s*=\s*)('.*')"         = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*[$]url64\s*=\s*)('.*')"         = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*[$]isoChecksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*[$]isoChecksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }

        ".\$($Latest.PackageName).nuspec" = @{
            "(?i)(^\s*<releaseNotes>)(?:.*)(<\/releaseNotes>)" = "`$1$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $regex32 = "WPILib_Windows32-.*\.iso"
    $regex64 = "WPILib_Windows64-.*\.iso"
    $url32 = $download_page.links | ? href -match $regex32 | select -First 1 -expand href
    $url64 = $download_page.links | ? href -match $regex64 | select -First 1 -expand href
    $url32 = $domain + $url32
    $url64 = $domain + $url64

    $Matches = $null
    $versionRegex = "(?:WPILib_Windows64-)(?<Version>.*)(?:\.iso)"
    $url64 -match $versionRegex | Out-Null
    $version = $Matches.Version

    $releaseNotesUrl = "$releases/tag/v${version}"

    return @{
        URL32 = $url32
        URL64 = $url64
        Version = $version
        ReleaseNotes = $releaseNotesUrl
    }
}

update
