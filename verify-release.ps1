<#
.SYNOPSIS
    Verifies that every APK in the releases repository matches the SHA-256 declared in the
    signed manifests, and that version.json agrees with apps.json.

.DESCRIPTION
    This is the guard that stops the exact defect that broke the update channel before:
    a published manifest that described a binary different from the one the users actually
    received. Publishing a manifest ahead of (or behind) its APK makes every in-app update
    fail its integrity check, silently or with a security error.

    ALWAYS run this before pushing the releases repository.

.EXAMPLE
    .\verify-release.ps1
#>
[CmdletBinding()]
param(
    [string] $RepositoryPath = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'
$ok = $true

function Get-Sha256([string] $path) {
    (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLower()
}

$apps = Get-Content -LiteralPath (Join-Path $RepositoryPath 'apps.json') -Raw | ConvertFrom-Json
$version = Get-Content -LiteralPath (Join-Path $RepositoryPath 'version.json') -Raw | ConvertFrom-Json

$entries = @()

$entries += [pscustomobject]@{
    id      = $apps.hub.id
    version = $apps.hub.version
    code    = $apps.hub.version_code
    sha     = ([string] $apps.hub.sha256).ToLower()
    file    = 'AboodLabs.apk'
}

foreach ($a in $apps.apps) {
    $file = switch ($a.id) {
        'tuckii' { 'Tuckii.apk' }
        'aman'   { 'Aman.apk' }
        default  { "$($a.id).apk" }
    }
    $entries += [pscustomobject]@{
        id      = $a.id
        version = $a.version
        code    = $a.version_code
        sha     = ([string] $a.sha256).ToLower()
        file    = $file
    }
}

foreach ($e in $entries) {
    $path = Join-Path $RepositoryPath $e.file

    if (-not (Test-Path -LiteralPath $path)) {
        Write-Output "MISSING APK   : $($e.id) -> $($e.file)"
        $ok = $false
        continue
    }

    if ([string]::IsNullOrWhiteSpace($e.sha)) {
        Write-Output "NO CHECKSUM   : $($e.id) -> $($e.file) has no sha256 in the manifest"
        $ok = $false
        continue
    }

    $actual = Get-Sha256 $path

    if ($actual -eq $e.sha) {
        Write-Output "OK            : $($e.id) v$($e.version) (code $($e.code))  $($e.file)"
    }
    else {
        Write-Output "HASH MISMATCH : $($e.id) -> $($e.file)"
        Write-Output "      manifest: $($e.sha)"
        Write-Output "      actual  : $actual"
        $ok = $false
    }
}

$tuckii = $entries | Where-Object { $_.id -eq 'tuckii' }

if ($version.version -ne $tuckii.version -or
    $version.version_code -ne $tuckii.code -or
    ([string] $version.sha256).ToLower() -ne $tuckii.sha) {
    Write-Output 'INCONSISTENT  : version.json does not agree with the tuckii entry in apps.json'
    $ok = $false
}
else {
    Write-Output "OK            : version.json agrees with apps.json (tuckii v$($version.version) / code $($version.version_code))"
}

Write-Output ''

if ($ok) {
    Write-Output 'All release checks passed.'
    exit 0
}
else {
    Write-Output 'RELEASE VERIFICATION FAILED - do not push.'
    exit 1
}