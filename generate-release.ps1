<#
.SYNOPSIS
    Regenerates and signs version.json / apps.json from the APKs in this repository.

.DESCRIPTION
    Every SHA-256 is computed directly from the APK on disk with Get-FileHash and written
    straight into the manifest. Nothing is ever typed by hand.

    This matters: a single mistyped character makes every in-app update fail its integrity
    check, which is precisely how the update channel was previously broken. Publishing a
    manifest that describes a binary other than the one users receive is the worst possible
    release bug, because it is silent.

    Run this AFTER copying the freshly built APKs into this repository.

.EXAMPLE
    .\generate-release.ps1 -TuckiiVersion 1.4.8 -TuckiiCode 22 `
                            -HubVersion 1.0.3  -HubCode 4 `
                            -AmanVersion 1.0.3 -AmanCode 4
#>
[CmdletBinding()]
param(
    [string] $RepositoryPath = $PSScriptRoot,

    [Parameter(Mandatory = $true)][string] $TuckiiVersion,
    [Parameter(Mandatory = $true)][int]    $TuckiiCode,
    [Parameter(Mandatory = $true)][string] $HubVersion,
    [Parameter(Mandatory = $true)][int]    $HubCode,
    [Parameter(Mandatory = $true)][string] $AmanVersion,
    [Parameter(Mandatory = $true)][int]    $AmanCode,

    [string] $Notes = 'Bug fixes and stability improvements.'
)

$ErrorActionPreference = 'Stop'

function Get-Sha256([string] $Path) {
    if (-not (Test-Path -LiteralPath $Path)) { throw "APK not found: $Path" }
    $h = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLower()
    if ($h.Length -ne 64) { throw "Unexpected SHA-256 length ($($h.Length)) for $Path" }
    return $h
}

$base = 'https://github.com/barry762vf/tuckii-releases/releases/download'

$shaHub    = Get-Sha256 (Join-Path $RepositoryPath 'AboodLabs.apk')
$shaTuckii = Get-Sha256 (Join-Path $RepositoryPath 'Tuckii.apk')
$shaAman   = Get-Sha256 (Join-Path $RepositoryPath 'Aman.apk')

Write-Output 'Hashes read from disk:'
Write-Output "  AboodLabs.apk  $shaHub"
Write-Output "  Tuckii.apk     $shaTuckii"
Write-Output "  Aman.apk       $shaAman"
Write-Output ''

$versionJson = [ordered]@{
    version      = $TuckiiVersion
    version_code = $TuckiiCode
    notes        = $Notes
    download_url = "$base/v$TuckiiVersion/Tuckii.apk"
    sha256       = $shaTuckii
}

$manifest = [ordered]@{
    hub  = [ordered]@{
        id            = 'hub'
        package_name  = 'com.tuckai.hub'
        name          = 'Abood Labs'
        tagline       = 'Central Ecosystem Portal & Suite Launcher'
        description   = 'The creative studio hub connecting Tuckii, Aman emergency guide, and companion tools. Every ecosystem update is cryptographically signed.'
        version       = $HubVersion
        version_code  = $HubCode
        download_url  = "$base/v$HubVersion-hub/AboodLabs.apk"
        sha256        = $shaHub
        category      = 'Ecosystem Portal'
        accent_color  = '#2E3AF2'
        status        = 'ready'
        features      = @(
            'Signed Update Manifests',
            'Signed APK Verification',
            'Suite Launcher',
            'Automatic Startup Updater',
            'Keystore Shield',
            'Deep Linking'
        )
    }
    apps = @(
        [ordered]@{
            id            = 'tuckii'
            package_name  = 'com.tuckai.app'
            name          = 'Tuckii'
            tagline       = 'Offline-First Bookmark & Media Manager'
            description   = 'High-speed social video downloader, offline reader, and neo-brutalist bookmark shelf with zero external exits.'
            version       = $TuckiiVersion
            version_code  = $TuckiiCode
            download_url  = "$base/v$TuckiiVersion/Tuckii.apk"
            sha256        = $shaTuckii
            category      = 'Media & Bookmarks'
            accent_color  = '#C96F4F'
            status        = 'ready'
            features      = @(
                'Signed Update Manifests',
                'Signed APK Verification',
                'Abood Labs Portal',
                '100% In-App Video Downloader',
                'Instant Search',
                'Batch Undo Delete'
            )
        },
        [ordered]@{
            id            = 'aman'
            package_name  = 'com.iraq.emergency.guide'
            name          = 'Aman | أمان'
            tagline       = 'Emergency Guide & Rapid Safety Response'
            description   = 'Complete emergency guide for Iraq: 911 SOS, first aid rescue, anti-extortion center, civil defense, and emergency numbers.'
            version       = $AmanVersion
            version_code  = $AmanCode
            download_url  = "$base/v$AmanVersion-aman/Aman.apk"
            sha256        = $shaAman
            category      = 'Emergency & Safety'
            accent_color  = '#FB3640'
            status        = 'ready'
            features      = @(
                'Signed Update Manifests',
                'Signed APK Verification',
                '911 Instant SOS',
                'Offline First Aid',
                'Anti-Extortion Center',
                'GPS Location Dispatcher',
                'Abood Labs Hub Integration'
            )
        }
    )
}

[IO.File]::WriteAllText(
    (Join-Path $RepositoryPath 'version.json'),
    ($versionJson | ConvertTo-Json -Depth 4),
    (New-Object Text.UTF8Encoding($false))
)

[IO.File]::WriteAllText(
    (Join-Path $RepositoryPath 'apps.json'),
    ($manifest | ConvertTo-Json -Depth 8),
    (New-Object Text.UTF8Encoding($false))
)

Write-Output 'Wrote version.json and apps.json.'
Write-Output ''

& (Join-Path $RepositoryPath 'sign-manifest.ps1') -Path `
    (Join-Path $RepositoryPath 'version.json'), (Join-Path $RepositoryPath 'apps.json')

Write-Output ''
& (Join-Path $RepositoryPath 'verify-manifest.ps1') -Path `
    (Join-Path $RepositoryPath 'version.json'), (Join-Path $RepositoryPath 'apps.json')