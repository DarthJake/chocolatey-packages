function Get-ETag() {
  param(
    [uri]$fileURL
  )

  $request = [System.Net.WebRequest]::CreateDefault($fileURL)

  try {
    $response = $request.GetResponse()
    $etag = $response.Headers.Get("ETag")
  } catch {
    Write-Error "There was a problem retrieving the ETag from: $fileURL"
  }

  return $etag
}

function Export-HashtableToSerial() {
  param(
    [hashtable]$table,
    [string]$destination
  )

  $serial = [System.Management.Automation.PSSerializer]::Serialize($table)
  $serial | Out-File -FilePath $destination
}

function Import-HashtableFromSerial() {
  param(
    [String]$path
  )

  $file = Get-Content -Path (Resolve-Path $path)
  [hashtable]$table = [System.Management.Automation.PSSerializer]::Deserialize($file)
  return $table
}