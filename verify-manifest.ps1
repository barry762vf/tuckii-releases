<#
.SYNOPSIS
    Verifies an Abood Labs release manifest against its detached `.sig` file.

.DESCRIPTION
    Local mirror of the check every shipped app performs before trusting a manifest.
    Run this after `sign-manifest.ps1` (and after any edit to version.json / apps.json)
    to make sure the published manifest still validates. Publishing a manifest whose
    signature does not match its bytes would silently stop all in-app updates.

.EXAMPLE
    .\verify-manifest.ps1 -Path .\version.json, .\apps.json
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]] $Path,

    [string] $PublicKeyPath = (Join-Path $env:USERPROFILE '.aboodlabs\keys\manifest-signing-ec-p256.spki.b64')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $PublicKeyPath)) {
    throw "Release public key not found at '$PublicKeyPath'."
}

$publicKeyB64 = (Get-Content -LiteralPath $PublicKeyPath -Raw).Trim()

$ecdsa = [System.Security.Cryptography.ECDsa]::Create()
$bytesRead = 0
[void] $ecdsa.ImportSubjectPublicKeyInfo([Convert]::FromBase64String($publicKeyB64), [ref] $bytesRead)

$exitCode = 0

try {
    foreach ($manifest in $Path) {
        $full = (Resolve-Path -LiteralPath $manifest).Path
        $signaturePath = "$full.sig"

        if (-not (Test-Path -LiteralPath $signaturePath)) {
            Write-Output "MISSING SIGNATURE : $full"
            $exitCode = 1
            continue
        }

        $payload = [IO.File]::ReadAllBytes($full)
        $signature = [Convert]::FromBase64String((Get-Content -LiteralPath $signaturePath -Raw).Trim())

        $ok = $ecdsa.VerifyData(
            $payload,
            $signature,
            [System.Security.Cryptography.HashAlgorithmName]::SHA256,
            [System.Security.Cryptography.DSASignatureFormat]::Rfc3279DerSequence
        )

        if ($ok) {
            Write-Output "VALID   : $full"
        }
        else {
            Write-Output "INVALID : $full  (signature does not match this manifest)"
            $exitCode = 1
        }
    }
}
finally {
    $ecdsa.Dispose()
}

exit $exitCode