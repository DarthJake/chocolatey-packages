Import-Module au
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

$domain = 'https://github.com'
$releases = "$domain/CrossTheRoadElec/Phoenix-Releases/releases"

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*[$]fileName\s*=\s*)('.*')" = "`$1'$($Latest.FileName)'"
            "(?i)(^\s*[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }

        ".\$($Latest.PackageName).nuspec" = @{
            "(?i)(^\s*<releaseNotes>)(?:.*)(<\/releaseNotes>)" = "`$1$($Latest.ReleaseNotes)`$2"
        }
    }
}

# Not called if there is no update 
function global:au_BeforeUpdate {
    $global:progressPreference = 'SilentlyContinue'
    $Latest.Checksum = Get-RemoteChecksum $Latest.URL
    $global:progressPreference = 'Continue'
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # Get URLs of latest installers
    $regex = "CTRE_Phoenix_Framework_v.*\.exe"
    $url = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href
    $url = $domain + $url

    # Determine version number of latest installers
    $Matches = $null
    $versionRegex = "(?:CTRE_Phoenix_Framework_v)(?<Version>.*)(?:\.exe)"
    $url -match $versionRegex | Out-Null
    $version = $Matches.Version

    # Determine installer file name
    $fileName = $Matches.0

    # Make release notes URL
    $releaseNotesUrl = "$releases/tag/v${version}"

    return @{
        URL = $url
        Version = $version
        FileName = $fileName
        ReleaseNotes = $releaseNotesUrl
    }
}

update -ChecksumFor none
