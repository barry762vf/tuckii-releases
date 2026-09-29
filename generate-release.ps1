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

    [switch] $PublishMedicalWay,
    [string] $MedicalWayVersion = '0.0.1',
    [int] $MedicalWayCode = 5,
    # alpha | beta | ready
    [string] $MedicalWayStage = 'alpha',

    # Date shown as "Updated" for the apps released in this run (the Hub and medicalWay).
    [string] $ReleaseDate = (Get-Date -Format 'yyyy-MM-dd'),

    [string] $Notes = 'Bug fixes and stability improvements.'
)

# ---------------------------------------------------------------------------------------------
# Version numbers (every Abood Labs app): MAJOR.MINOR.PATCH
#   PATCH  (1.2.3 -> 1.2.4)  only bug fixes
#   MINOR  (1.2.4 -> 1.3.0)  new features that don't change how the app is used
#   MAJOR  (1.3.0 -> 2.0.0)  big changes: redesign, removed features, anything that breaks old habits
#   0.x.y means "not finished yet": status 'alpha' (early) or 'beta' (nearly ready).
#   version_code must go up by at least 1 with EVERY release, or phones will not see the update.
# ---------------------------------------------------------------------------------------------
#
# Store texts: plain English that anyone can read. Taglines under 40 characters, descriptions one or two
# short sentences, features 2-6 words each. Say what the app does for the person, not how it is built.

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
$shaMedicalWay = ''
if ($PublishMedicalWay) {
    $shaMedicalWay = Get-Sha256 (Join-Path $RepositoryPath 'MedicalWay.apk')
}

Write-Output 'Hashes read from disk:'
Write-Output "  AboodLabs.apk  $shaHub"
Write-Output "  Tuckii.apk     $shaTuckii"
Write-Output "  Aman.apk       $shaAman"
Write-Output "  Matbakhi.apk   $shaKitchen"
if ($PublishMinhaj) { Write-Output "  Minhaj.apk     $shaMinhaj" }
if ($PublishMedicalWay) { Write-Output "  MedicalWay.apk $shaMedicalWay" }
Write-Output ''

$versionJson = [ordered]@{
    version      = $TuckiiVersion
    version_code = $TuckiiCode
    notes        = $Notes
    download_url = "$base/v$TuckiiVersion/Tuckii.apk"
    sha256       = $shaTuckii
}

function Get-Size([string] $Name) { return (Get-Item -LiteralPath (Join-Path $RepositoryPath $Name)).Length }
$logos = 'https://raw.githubusercontent.com/barry762vf/tuckii-releases/main/logos'

$manifest = [ordered]@{
    hub  = [ordered]@{
        id            = 'hub'
        package_name  = 'com.tuckai.hub'
        name          = 'Abood Labs'
        tagline       = 'Get and update every Abood Labs app'
        description   = 'One place to install Abood Labs apps and keep them up to date. Every download is checked before it installs.'
        version       = $HubVersion
        version_code  = $HubCode
        download_url  = "$base/v$HubVersion-hub/AboodLabs.apk"
        sha256        = $shaHub
        category      = 'Tools'
        accent_color  = '#2E3AF2'
        logo_url      = "$logos/abood-labs.png"
        status        = 'ready'
        size_bytes    = Get-Size 'AboodLabs.apk'
        updated       = $ReleaseDate
        min_android   = '8.0'
        language      = 'English'
        whats_new     = 'A new store look: clear app pages with screenshots, one-tap updates, and the app list keeps working offline.'
        privacy       = 'Only downloads the app list and the apps you choose. No account, no tracking.'
        features      = @('All Abood Labs apps in one place', 'Updates you can trust', 'Works offline with the saved list')
    }
    apps = @(
        [ordered]@{
            id            = 'tuckii'
            package_name  = 'com.tuckai.app'
            name          = 'Tuckii'
            tagline       = 'Save links and read them later'
            description   = 'Keep links, articles and videos in one tidy place and read them later, even without internet.'
            version       = $TuckiiVersion
            version_code  = $TuckiiCode
            download_url  = "$base/v$TuckiiVersion/Tuckii.apk"
            sha256        = $shaTuckii
            category      = 'Reading'
            accent_color  = '#C96F4F'
            logo_url      = "$logos/tuckii.jpg"
            status        = 'ready'
            size_bytes    = Get-Size 'Tuckii.apk'
            min_android   = '8.0'
            language      = 'English'
            privacy       = 'Your bookmarks stay on your phone. Saving a link opens that page to read its title. Optional video downloads send the link to outside services.'
            features      = @('Read saved pages offline', 'Fast search', 'Collections', 'Undo if you delete by mistake')
        },
        [ordered]@{
            id            = 'aman'
            package_name  = 'com.iraq.emergency.guide'
            name          = 'Aman'
            name_local    = 'أمان'
            tagline       = 'Emergency help for Iraq'
            description   = 'Call for help fast, find every emergency number in Iraq, and follow first-aid steps that work without internet.'
            version       = $AmanVersion
            version_code  = $AmanCode
            download_url  = "$base/v$AmanVersion-aman/Aman.apk"
            sha256        = $shaAman
            category      = 'Safety'
            accent_color  = '#FB3640'
            logo_url      = "$logos/aman.png"
            status        = 'ready'
            size_bytes    = Get-Size 'Aman.apk'
            min_android   = '7.0'
            language      = 'Arabic'
            features      = @('One-tap SOS call', 'First aid that works offline', 'All emergency numbers', 'Help with online blackmail')
        },
        [ordered]@{
            id            = 'kitchen'
            package_name  = 'com.tuckai.kitchen'
            name          = 'Matbakhi'
            name_local    = 'مطبخي'
            tagline       = 'What can I cook today?'
            description   = '50 Iraqi recipes, a pantry and shopping list, and step-by-step cooking. It suggests dishes from what you already have.'
            version       = $KitchenVersion
            version_code  = $KitchenCode
            download_url  = "$base/v$KitchenVersion-kitchen/Matbakhi.apk"
            sha256        = $shaKitchen
            category      = 'Food & cooking'
            accent_color  = '#0F372F'
            logo_url      = "$logos/matbakhi.png"
            status        = 'ready'
            size_bytes    = Get-Size 'Matbakhi.apk'
            min_android   = '8.0'
            language      = 'Arabic'
            privacy       = 'No account. Your recipes and pantry stay on your phone; the internet is only used for updates.'
            features      = @('50 Iraqi recipes', 'Ideas from what you have', 'Pantry and shopping list', 'Step-by-step cooking')
        },
        [ordered]@{
            id            = 'minhaj'
            package_name  = 'com.tuckai.minhaj'
            name          = 'Minhaj'
            name_local    = 'منهاج'
            tagline       = 'Read the Quran every day'
            description   = 'Read and listen to the Quran, set a daily goal and track your progress, in the app or with your own printed Mushaf. Beta: the text checks are automatic; a scholar''s review is still pending.'
            version       = $MinhajVersion
            version_code  = $MinhajCode
            download_url  = if ($PublishMinhaj) { "$base/v$MinhajVersion-minhaj-beta/Minhaj.apk" } else { '' }
            sha256        = $shaMinhaj
            category      = 'Quran'
            accent_color  = '#0D4B3D'
            logo_url      = "$logos/minhaj.png"
            status        = if ($PublishMinhaj) { 'beta' } else { 'coming_soon' }
            min_android   = '8.0'
            language      = 'Arabic'
            features      = @('Read without internet', 'Listen to recitations', 'Daily goal and reminder', 'Track your printed Mushaf')
        }
    )
}
if ($PublishMinhaj) { $manifest['apps'][3]['size_bytes'] = Get-Size 'Minhaj.apk' }

if ($PublishMedicalWay) {
    # Newest app first, shown as the store's featured app.
    $manifest['apps'] = @(
        [ordered]@{
            id            = 'medicalway'
            package_name  = 'com.tuckai.medicalway'
            name          = 'medicalWay'
            tagline       = 'Study medicine the smart way'
            description   = 'Write on your lecture slides, record the lecture, and turn it into flashcards and quizzes. Clinical calculators, lab values and more, on your phone or tablet, even offline.'
            version       = $MedicalWayVersion
            version_code  = $MedicalWayCode
            download_url  = "$base/v$MedicalWayVersion-medicalway/MedicalWay.apk"
            sha256        = $shaMedicalWay
            category      = 'Education'
            accent_color  = '#CB3534'
            logo_url      = "$logos/medicalway.png"
            status        = $MedicalWayStage
            featured      = $true
            size_bytes    = Get-Size 'MedicalWay.apk'
            updated       = $ReleaseDate
            min_android   = '8.0'
            language      = 'English'
            whats_new     = 'Daily review with a streak and reminders, sync between your phone and tablet, a new notebook toolbar with a laser and reading mode, and a fresh look. Open the app to see how each one works.'
            privacy       = 'Your notes stay on your device unless you sign in: then notebooks, cards and progress sync to your own account (packed small; PDFs, photos and recordings stay on the device). Also only what you choose: the AI tutor (with your own key) and feedback you send.'
            features      = @(
                'Write on PDF, PowerPoint and Word slides',
                'Daily review with a streak',
                'Sync between phone and tablet',
                'Record lectures while you write',
                'Flashcards and practice quizzes',
                'Calculators, lab values and mnemonics',
                'Optional AI tutor'
            )
        }
    ) + @($manifest['apps'])
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
# Abood Labs — official Android apps

Download the apps here, or get them all (and their updates) in the **Abood Labs** app.

> **Safe by design.** Every app is signed with the official Abood Labs key, and the app list
> (`apps.json`) is signed too. Before anything installs, the apps check the list's signature, the
> file's SHA-256 checksum and the app's signing certificate. This file is written by
> `.\generate-release.ps1` — checksums are never typed by hand.
>
> **Version numbers** follow MAJOR.MINOR.PATCH: a bug fix raises the last number (1.2.3 → 1.2.4),
> a new feature raises the middle one (1.2.4 → 1.3.0), a big change raises the first (1.3.0 → 2.0.0).
> Versions starting with 0 are not finished yet (alpha or beta).

---
__MEDICALWAY_SECTION__
### Abood Labs — get and update every Abood Labs app (v__HUB_VER__)
- **[Download AboodLabs.apk](https://github.com/barry762vf/tuckii-releases/releases/download/v__HUB_VER__-hub/AboodLabs.apk)** · `com.tuckai.hub` · versionCode __HUB_CODE__
- SHA-256: `__HUB_SHA__`
- One place to install Abood Labs apps and keep them up to date. Every download is checked before it installs.

---

### Tuckii — save links and read them later (v__TUCKII_VER__)
- **[Download Tuckii.apk](https://github.com/barry762vf/tuckii-releases/releases/download/v__TUCKII_VER__/Tuckii.apk)** · `com.tuckai.app` · versionCode __TUCKII_CODE__
- SHA-256: `__TUCKII_SHA__`
- Keep links, articles and videos in one tidy place and read them later, even without internet.
- Your bookmarks stay on your phone. Saving a link opens that page to read its title. Optional video
  downloads send the link to outside services that are not part of Abood Labs.

---

### Aman (أمان) — emergency help for Iraq (v__AMAN_VER__)
- **[Download Aman.apk](https://github.com/barry762vf/tuckii-releases/releases/download/v__AMAN_VER__-aman/Aman.apk)** · `com.iraq.emergency.guide` · versionCode __AMAN_CODE__
- SHA-256: `__AMAN_SHA__`
- Call for help fast, find every emergency number in Iraq, and follow first-aid steps that work without internet. In Arabic.

---

### Matbakhi (مطبخي) — what can I cook today? (v__KITCHEN_VER__)
- **[Download Matbakhi.apk](https://github.com/barry762vf/tuckii-releases/releases/download/v__KITCHEN_VER__-kitchen/Matbakhi.apk)** · `com.tuckai.kitchen` · versionCode __KITCHEN_CODE__
- SHA-256: `__KITCHEN_SHA__`
- 50 Iraqi recipes, a pantry and shopping list, and step-by-step cooking. In Arabic, no account;
  the internet is only used for updates.

---

### Minhaj (منهاج) — read the Quran every day (__MINHAJ_STATE__)
- **[Download Minhaj.apk (v__MINHAJ_VER__)](__MINHAJ_URL__)** · `com.tuckai.minhaj` · versionCode __MINHAJ_CODE__
- SHA-256: `__MINHAJ_SHA__`
- Read and listen to the Quran, set a daily goal and track your progress, in the app or with your own printed Mushaf. In Arabic.
- **Beta:** the text checks are automatic; a scholar's review is still pending.

---

*All apps are signed with the same official Abood Labs key, so they can install and update each other safely.*
'@

$minhajUrl = if ($PublishMinhaj) { "$base/v$MinhajVersion-minhaj-beta/Minhaj.apk" } else { '#' }
$minhajState = if ($PublishMinhaj) { 'public beta' } else { 'preview' }
$readme = $readme.Replace('__TUCKII_VER__', $TuckiiVersion).Replace('__TUCKII_CODE__', [string] $TuckiiCode).Replace('__TUCKII_SHA__', $shaTuckii).Replace('__HUB_VER__', $HubVersion).Replace('__HUB_CODE__', [string] $HubCode).Replace('__HUB_SHA__', $shaHub).Replace('__AMAN_VER__', $AmanVersion).Replace('__AMAN_CODE__', [string] $AmanCode).Replace('__AMAN_SHA__', $shaAman).Replace('__KITCHEN_VER__', $KitchenVersion).Replace('__KITCHEN_CODE__', [string] $KitchenCode).Replace('__KITCHEN_SHA__', $shaKitchen).Replace('__MINHAJ_STATE__', $minhajState).Replace('__MINHAJ_VER__', $MinhajVersion).Replace('__MINHAJ_CODE__', [string] $MinhajCode).Replace('__MINHAJ_SHA__', $shaMinhaj).Replace('__MINHAJ_URL__', $minhajUrl)

$medicalWaySection = ''
if ($PublishMedicalWay) {
    $medicalWaySection = @'

### medicalWay — study medicine the smart way (v__MW_VER__, __MW_STAGE__)
- **[Download MedicalWay.apk](https://github.com/barry762vf/tuckii-releases/releases/download/v__MW_VER__-medicalway/MedicalWay.apk)** · `com.tuckai.medicalway` · versionCode __MW_CODE__
- SHA-256: `__MW_SHA__`
- Write on your lecture slides, record the lecture, and turn it into flashcards and quizzes. Clinical
  calculators, lab values and more, on your phone or tablet, even offline.
- Daily review with a streak, and sync between your phone and tablet when you sign in with Google.
- Your notes stay on your device unless you sign in: then notebooks, cards and progress sync to your
  own account. PDFs, photos and recordings stay on the device. The AI tutor uses your own key.
- **__MW_STAGE__:** an early version. Things may change and you may find bugs.

---
'@
    $stage = (Get-Culture).TextInfo.ToTitleCase($MedicalWayStage)
    $medicalWaySection = $medicalWaySection.Replace('__MW_VER__', $MedicalWayVersion).Replace('__MW_CODE__', [string] $MedicalWayCode).Replace('__MW_SHA__', $shaMedicalWay).Replace('__MW_STAGE__', $stage)
}
$readme = $readme.Replace('__MEDICALWAY_SECTION__', $medicalWaySection)

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
