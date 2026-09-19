<#
.SYNOPSIS
    Signs an Abood Labs release manifest with the offline ECDSA P-256 release key.

.DESCRIPTION
    Produces a detached, base64-encoded signature in `<file>.sig`, using the RFC 3279
    DER SEQUENCE encoding that Java/Android's `SHA256withECDSA` expects.

    Every shipped Abood Labs app verifies the manifest against the matching PUBLIC key
    before trusting a single field in it. Because the PRIVATE key never touches GitHub,
    a full compromise of the public `tuckii-releases` repository still cannot forge a
    manifest — which is what stops an attacker from pointing installed apps at a hacked
    APK.

    The private key is read from OUTSIDE this repository (default:
    %USERPROFILE%\.aboodlabs\keys\manifest-signing-ec-p256.pkcs8.b64).
    NEVER commit the private key.

.EXAMPLE
    .\sign-manifest.ps1 -Path .\version.json, .\apps.json
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]] $Path,

    [string] $PrivateKeyPath = (Join-Path $env:USERPROFILE '.aboodlabs\keys\manifest-signing-ec-p256.pkcs8.b64')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $PrivateKeyPath)) {
    throw "Release signing key not found at '$PrivateKeyPath'. Refusing to publish an unsigned manifest."
}

$privateKeyB64 = (Get-Content -LiteralPath $PrivateKeyPath -Raw).Trim()

$ecdsa = [System.Security.Cryptography.ECDsa]::Create()
$bytesRead = 0
[void] $ecdsa.ImportPkcs8PrivateKey([Convert]::FromBase64String($privateKeyB64), [ref] $bytesRead)

try {
    foreach ($manifest in $Path) {
        if (-not (Test-Path -LiteralPath $manifest)) {
            throw "Manifest not found: $manifest"
        }

        $full = (Resolve-Path -LiteralPath $manifest).Path
        $payload = [IO.File]::ReadAllBytes($full)

        $signature = $ecdsa.SignData(
            $payload,
            [System.Security.Cryptography.HashAlgorithmName]::SHA256,
            [System.Security.Cryptography.DSASignatureFormat]::Rfc3279DerSequence
        )

        $signaturePath = "$full.sig"
        Set-Content -LiteralPath $signaturePath -Value ([Convert]::ToBase64String($signature)) -NoNewline -Encoding ASCII

        Write-Output "signed : $full"
        Write-Output "     -> $signaturePath"
    }
}
finally {
    $ecdsa.Dispose()
}