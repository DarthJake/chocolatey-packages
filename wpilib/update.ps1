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

# Not called if there is no update 
function global:au_BeforeUpdate {}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    # Get URLs of latest installers
    $regex32 = "WPILib_Windows32-.*\.iso"
    $regex64 = "WPILib_Windows64-.*\.iso"
    $url32 = $download_page.links | Where-Object href -match $regex32 | Select-Object -First 1 -expand href
    $url64 = $download_page.links | Where-Object href -match $regex64 | Select-Object -First 1 -expand href
    $url32 = $domain + $url32
    $url64 = $domain + $url64

    # Determine version of latest installers
    $Matches = $null
    $versionRegex = "(?:WPILib_Windows64-)(?<Version>.*)(?:\.iso)"
    $url64 -match $versionRegex | Out-Null
    $version = $Matches.Version

    # Get checksums of latest installers
    # 32
    $download_page.RawContent | ForEach-Object {$_ -replace "<[^ ]+>", "`n"} | `
        ForEach-Object {$_ -match "(?<checksum32>[0-9a-fA-F]{64})(?:\s*Win32\/WPILib_Windows32-$version.iso)"}
    $Latest.Checksum32 = $Matches.checksum32

    # 64
    $download_page.RawContent | ForEach-Object {$_ -replace "<[^ ]+>", "`n"} | `
        ForEach-Object {$_ -match "(?<checksum64>[0-9a-fA-F]{64})(?:\s*Win64\/WPILib_Windows64-$version.iso)"}
    $Latest.Checksum64 = $Matches.checksum64

    # Make release notes URL
    $releaseNotesUrl = "$releases/tag/v${version}"

    return @{
        URL32 = $url32
        URL64 = $url64
        Version = $version
        ReleaseNotes = $releaseNotesUrl
    }
}

update -ChecksumFor none
