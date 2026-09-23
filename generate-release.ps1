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
                            -AmanVersion 1.0.3 -AmanCode 4 `
                            -KitchenVersion 1.0.0 -KitchenCode 1
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
    [Parameter(Mandatory = $true)][string] $KitchenVersion,
    [Parameter(Mandatory = $true)][int]    $KitchenCode,

    [switch] $PublishMinhaj,
    [string] $MinhajVersion = '1.0.0',
    [int] $MinhajCode = 1,

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

$shaHub     = Get-Sha256 (Join-Path $RepositoryPath 'AboodLabs.apk')
$shaTuckii  = Get-Sha256 (Join-Path $RepositoryPath 'Tuckii.apk')
$shaAman    = Get-Sha256 (Join-Path $RepositoryPath 'Aman.apk')
$shaKitchen = Get-Sha256 (Join-Path $RepositoryPath 'Matbakhi.apk')
$shaMinhaj = ''
if ($PublishMinhaj) {
    $shaMinhaj = Get-Sha256 (Join-Path $RepositoryPath 'Minhaj.apk')
}

Write-Output 'Hashes read from disk:'
Write-Output "  AboodLabs.apk  $shaHub"
Write-Output "  Tuckii.apk     $shaTuckii"
Write-Output "  Aman.apk       $shaAman"
Write-Output "  Matbakhi.apk   $shaKitchen"
if ($PublishMinhaj) { Write-Output "  Minhaj.apk     $shaMinhaj" }
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
        description   = 'The creative studio hub connecting Tuckii, Aman, Matbakhi, and Minhaj. Every ecosystem update is cryptographically signed.'
        version       = $HubVersion
        version_code  = $HubCode
        download_url  = "$base/v$HubVersion-hub/AboodLabs.apk"
        sha256        = $shaHub
        category      = 'Ecosystem Portal'
        accent_color  = '#2E3AF2'
        logo_url      = 'https://raw.githubusercontent.com/barry762vf/tuckii-releases/main/logos/abood-labs.png'
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
            logo_url      = 'https://raw.githubusercontent.com/barry762vf/tuckii-releases/main/logos/tuckii.jpg'
            status        = 'ready'
            features      = @(
                'Signed Update Manifests',
                'Signed APK Verification',
                'Abood Labs Portal',
                '100% In-App Video Downloader',
                'Instant Search',
                'Batch Undo Delete',
                'Scoped Matbakhi collaboration collection',
                'Stable bookmark IDs and private notes stay private'
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
            logo_url      = 'https://raw.githubusercontent.com/barry762vf/tuckii-releases/main/logos/aman.png'
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
        },
        [ordered]@{
            id            = 'kitchen'
            package_name  = 'com.tuckai.kitchen'
            name          = 'مطبخي | Matbakhi'
            tagline       = 'Offline Pantry, Recipes & Cook-Along Companion'
            description   = 'Fully offline Arabic kitchen companion with 50 built-in regional recipes, pantry tracking, ingredient matching, and guided cook mode.'
            version       = $KitchenVersion
            version_code  = $KitchenCode
            download_url  = "$base/v$KitchenVersion-kitchen/Matbakhi.apk"
            sha256        = $shaKitchen
            category      = 'Kitchen & Recipes'
            accent_color  = '#0F372F'
            logo_url      = 'https://raw.githubusercontent.com/barry762vf/tuckii-releases/main/logos/matbakhi.png'
            status        = 'ready'
            features      = @(
                'Signed Update Manifests',
                'Signed APK Verification',
                '100% Offline, No Accounts',
                '50 Built-in Regional Recipes',
                'Ingredient Match Engine',
                'Guided Cook Mode',
                'Tuckii Collaboration Link',
                'Persistent imported recipe drafts',
                'Source provenance and duplicate-import protection'
            )
        },
        [ordered]@{
            id            = 'minhaj'
            package_name  = 'com.tuckai.minhaj'
            name          = 'منهاج'
            tagline       = 'رفيق القرآن الكريم والمسار اليومي'
            description   = 'قراءة القرآن، آيات وأدعية قرآنية مختارة، الاستماع، ومتابعة التقدم داخل التطبيق أو من المصحف الورقي.'
            version       = $MinhajVersion
            version_code  = $MinhajCode
            download_url  = if ($PublishMinhaj) { "$base/v$MinhajVersion-minhaj-beta/Minhaj.apk" } else { '' }
            sha256        = $shaMinhaj
            category      = 'القرآن الكريم'
            accent_color  = '#0D4B3D'
            logo_url      = 'https://raw.githubusercontent.com/barry762vf/tuckii-releases/main/logos/minhaj.png'
            status        = if ($PublishMinhaj) { 'beta' } else { 'coming_soon' }
            features      = @('قراءة دون اتصال', 'المصحف الورقي', 'آيات وأدعية من القرآن', 'استماع وتذكير يومي')
        }
    )
}

# Manifests MUST be written with LF line endings.
# `.gitattributes` normalises version.json / apps.json / *.sig to LF, so signing CRLF bytes
# produces a signature that does NOT match the file GitHub actually serves — which silently
# breaks every in-app update (the app rejects the manifest and refuses to update). LF is
# therefore enforced here and asserted before signing.
function ConvertTo-LfText([string] $text) {
    return $text.Replace("`r`n", "`n").Replace("`r", "`n")
}

$versionJsonText = ConvertTo-LfText (($versionJson | ConvertTo-Json -Depth 4) + "`n")
$appsJsonText = ConvertTo-LfText (($manifest | ConvertTo-Json -Depth 8) + "`n")

[IO.File]::WriteAllText(
    (Join-Path $RepositoryPath 'version.json'),
    $versionJsonText,
    (New-Object Text.UTF8Encoding($false))
)

[IO.File]::WriteAllText(
    (Join-Path $RepositoryPath 'apps.json'),
    $appsJsonText,
    (New-Object Text.UTF8Encoding($false))
)

# Fail fast if any CR survived: a CRLF manifest can never carry a valid published signature.
foreach ($name in @('version.json', 'apps.json')) {
    $bytes = [IO.File]::ReadAllBytes((Join-Path $RepositoryPath $name))
    if ($bytes -contains 13) {
        throw "$name contains CR bytes. It must be LF-only, otherwise the signature will not match the served file."
    }
}

# --- Regenerate README.md so it can never drift from the APKs on disk ---
# Placeholders are used (not interpolation) so the markdown backticks survive PowerShell's
# escape rules. Every hash comes from Get-FileHash above — never typed by hand.
$readme = @'
# ⚡ Abood Labs — Official Android Releases

Official public distribution repository for the **Abood Labs** ecosystem suite of Android applications.

> Every `*.apk` here is signed with the unified ecosystem key, and `version.json` / `apps.json`
> are published with detached ECDSA P-256 signatures (`*.sig`). Installed apps verify the
> signature, the SHA-256 checksum **and** the APK's signing certificate before installing.
> Regenerate this file with `.\generate-release.ps1` — never edit hashes by hand.

---

### 1. 🔖 Tuckii — Offline-First Media & Bookmark Manager (v__TUCKII_VER__)
- **[Download Tuckii.apk (v__TUCKII_VER__)](https://github.com/barry762vf/tuckii-releases/releases/download/v__TUCKII_VER__/Tuckii.apk)**
- **Package ID:** `com.tuckai.app`
- **Build:** `versionCode __TUCKII_CODE__`
- **SHA-256 Checksum:** `__TUCKII_SHA__`
- **Highlights:**
  - Update prompts restored for users on older builds (version-code driven detection).
  - Every update verified: manifest signature, SHA-256 and APK signing certificate.
  - Signed update manifests — a compromised repository cannot redirect installs.
  - 100% in-app video downloader, instant search, batch undo.
  - Scoped Matbakhi collaboration collection with stable record identity; private notes are not shared.

---

### 2. 🚀 Abood Labs — Creative Studio Hub & Ecosystem Portal (v__HUB_VER__)
- **[Download AboodLabs.apk (v__HUB_VER__)](https://github.com/barry762vf/tuckii-releases/releases/download/v__HUB_VER__-hub/AboodLabs.apk)**
- **Package ID:** `com.tuckai.hub`
- **Build:** `versionCode __HUB_CODE__`
- **SHA-256 Checksum:** `__HUB_SHA__`
- **Highlights:**
  - Signature-verified suite manifest; installs pinned to the official certificate.
  - Suite launcher with automatic startup update checks for all ecosystem apps.
  - Native launch and 1-tap in-app install for available suite apps.
  - Horizontal, tap-to-enlarge screenshots captured from the Android emulator.
  - Full-width Arabic app names stay on one line without clipping.

---

### 3. 🚨 Aman | أمان — Emergency Guide & Rapid Safety Response (v__AMAN_VER__)
- **[Download Aman.apk (v__AMAN_VER__)](https://github.com/barry762vf/tuckii-releases/releases/download/v__AMAN_VER__-aman/Aman.apk)**
- **Package ID:** `com.iraq.emergency.guide`
- **Build:** `versionCode __AMAN_CODE__`
- **SHA-256 Checksum:** `__AMAN_SHA__`
- **Highlights:**
  - Update manifest verified natively before the JavaScript layer is trusted.
  - 911 Instant SOS and complete unified Iraqi emergency directory.
  - 100% offline first aid protocols and anti-extortion dispatch.
  - In-app OTA update checker querying the Abood Labs distribution channel.

---

### 4. 🍲 مطبخي (Matbakhi) — Offline Pantry, Recipes & Cook-Along Companion (v__KITCHEN_VER__)
- **[Download Matbakhi.apk (v__KITCHEN_VER__)](https://github.com/barry762vf/tuckii-releases/releases/download/v__KITCHEN_VER__-kitchen/Matbakhi.apk)**
- **Package ID:** `com.tuckai.kitchen`
- **Build:** `versionCode __KITCHEN_CODE__`
- **SHA-256 Checksum:** `__KITCHEN_SHA__`
- **Highlights:**
  - 100% offline, Arabic-only, RTL-first — no accounts, no network permission at all.
  - 50 built-in Iraqi recipes with real ingredients and steps, plus a full recipe builder.
  - "ماذا أطبخ؟" ingredient-match engine and a guided cook mode that updates the pantry
    and shopping list automatically.
  - Tuckii imports become persistent, editable drafts with source provenance and duplicate protection.
    User approval remains controlled by Tuckii.
  - Signed update manifests and APK signer pinning like every other app in the suite.

---

### 5. منهاج — Quran Companion (__MINHAJ_STATE__)
- **[Download Minhaj.apk (v__MINHAJ_VER__)](__MINHAJ_URL__)**
- **Package ID:** `com.tuckai.minhaj`
- **Build:** `versionCode __MINHAJ_CODE__`
- **SHA-256 Checksum:** `__MINHAJ_SHA__`
- Arabic-first reading, listening and progress tracking for in-app or physical Mushaf use.
- Curated Quran passages and Quranic supplications; no hadith or tafsir section.
- **Beta:** content checks are automated and are not scholarly approval; qualified review is still pending.

---

*All applications are signed with the shared ecosystem key for trusted in-app cross-installation.
Manifest checksums are computed from the APKs by `generate-release.ps1` — never edited by hand.*
'@

$minhajUrl = if ($PublishMinhaj) { "$base/v$MinhajVersion-minhaj-beta/Minhaj.apk" } else { '#' }
$minhajState = if ($PublishMinhaj) { 'public beta' } else { 'preview' }
$readme = $readme.Replace('__TUCKII_VER__', $TuckiiVersion).Replace('__TUCKII_CODE__', [string] $TuckiiCode).Replace('__TUCKII_SHA__', $shaTuckii).Replace('__HUB_VER__', $HubVersion).Replace('__HUB_CODE__', [string] $HubCode).Replace('__HUB_SHA__', $shaHub).Replace('__AMAN_VER__', $AmanVersion).Replace('__AMAN_CODE__', [string] $AmanCode).Replace('__AMAN_SHA__', $shaAman).Replace('__KITCHEN_VER__', $KitchenVersion).Replace('__KITCHEN_CODE__', [string] $KitchenCode).Replace('__KITCHEN_SHA__', $shaKitchen).Replace('__MINHAJ_STATE__', $minhajState).Replace('__MINHAJ_VER__', $MinhajVersion).Replace('__MINHAJ_CODE__', [string] $MinhajCode).Replace('__MINHAJ_SHA__', $shaMinhaj).Replace('__MINHAJ_URL__', $minhajUrl)

[IO.File]::WriteAllText(
    (Join-Path $RepositoryPath 'README.md'),
    (ConvertTo-LfText $readme),
    (New-Object Text.UTF8Encoding($false))
)

Write-Output 'Wrote version.json, apps.json and README.md.'
Write-Output ''

& (Join-Path $RepositoryPath 'sign-manifest.ps1') -Path `
    (Join-Path $RepositoryPath 'version.json'), (Join-Path $RepositoryPath 'apps.json')

Write-Output ''
& (Join-Path $RepositoryPath 'verify-manifest.ps1') -Path `
    (Join-Path $RepositoryPath 'version.json'), (Join-Path $RepositoryPath 'apps.json')
