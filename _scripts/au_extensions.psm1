# We just specify the functions we want to export.
# The file containing the functions is expected
# to be named using the same name.
$functions = @(
    'ETagHelpers'
)

$functions | ForEach-Object {
    $path = "$PSScriptRoot\$_.ps1"
    if (Test-Path $path) {
        . $path
        if (Get-Command $_ -ErrorAction SilentlyContinue) {
            Export-ModuleMember -Function $_
        }
    } else {
        Write-Host "`n`nUnable to find script $_ to import it!!!`n`n"
    }
}