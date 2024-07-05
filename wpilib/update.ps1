Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

$releases = "https://github.com/wpilibsuite/allwpilib/releases"
$latestRelease = $releases + "/latest"

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url\s*=\s*)('.*')"         = "`$1'$($Latest.URL)'"
            "(?i)(^\s*[$]isoChecksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }

        ".\$($Latest.PackageName).nuspec" = @{
            "(?i)(^\s*<releaseNotes>)(?:.*)(<\/releaseNotes>)" = "`$1$($Latest.ReleaseNotes)`$2"
        }
    }
}

# Not called if there is no update 
function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $latestRelease

    # Get URL and version of latest installer
    $regex = "WPILib_Windows-.*\.iso"
    $url = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href
    $version = $url -split '/' | Select-Object -Last 1 -Skip 2 | ForEach-Object { $_.Trim('v') }

    # Get checksum of latest installer
    $checksum = ($download_page.RawContent | Select-String -Pattern "([0-9a-fA-F]{64})(?:\s*WPILib_Windows-$version.iso)").Matches.Groups[1].Value

    # Make release notes URL
    $releaseNotesUrl = "$releases/tag/v${version}"

    return @{
        URL = $url
        Version = $version
        Checksum = $checksum
        ReleaseNotes = $releaseNotesUrl
    }
}

update -ChecksumFor none
