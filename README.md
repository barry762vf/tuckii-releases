# ⚡ Abood Labs — Official Android Releases

Official public distribution repository for the **Abood Labs** ecosystem suite of Android applications.

> Every `*.apk` here is signed with the unified ecosystem key, and `version.json` / `apps.json`
> are published with detached ECDSA P-256 signatures (`*.sig`). Installed apps verify the
> signature, the SHA-256 checksum **and** the APK's signing certificate before installing.
> Regenerate this file with `.\generate-release.ps1` — never edit hashes by hand.

---

### 1. 🔖 Tuckii — Offline-First Media & Bookmark Manager (v1.4.9)
- **[Download Tuckii.apk (v1.4.9)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.4.9/Tuckii.apk)**
- **Package ID:** `com.tuckai.app`
- **Build:** `versionCode 23`
- **SHA-256 Checksum:** `1d62294d8d4e0f41069794c6cec62ddf529cb6b7f16578ef66832406c9eee57f`
- **Highlights:**
  - Update prompts restored for users on older builds (version-code driven detection).
  - Every update verified: manifest signature, SHA-256 and APK signing certificate.
  - Signed update manifests — a compromised repository cannot redirect installs.
  - 100% in-app video downloader, instant search, batch undo.

---

### 2. 🚀 Abood Labs — Creative Studio Hub & Ecosystem Portal (v1.0.3)
- **[Download AboodLabs.apk (v1.0.3)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.0.3-hub/AboodLabs.apk)**
- **Package ID:** `com.tuckai.hub`
- **Build:** `versionCode 4`
- **SHA-256 Checksum:** `860e5baddff0254b84dd966078200c075c71194a75e4f42a2c8a250103b9e272`
- **Highlights:**
  - Signature-verified suite manifest; installs pinned to the official certificate.
  - Suite launcher with automatic startup update checks for all ecosystem apps.
  - Native launch and 1-tap in-app install for Tuckii and Aman.

---

### 3. 🚨 Aman | أمان — Emergency Guide & Rapid Safety Response (v1.0.6)
- **[Download Aman.apk (v1.0.6)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.0.6-aman/Aman.apk)**
- **Package ID:** `com.iraq.emergency.guide`
- **Build:** `versionCode 6`
- **SHA-256 Checksum:** `bf4b6492875e49cdf02f70f56e23a8b35bf94c91aaeb093e4f970bfa81f426e0`
- **Highlights:**
  - Update manifest verified natively before the JavaScript layer is trusted.
  - 911 Instant SOS and complete unified Iraqi emergency directory.
  - 100% offline first aid protocols and anti-extortion dispatch.
  - In-app OTA update checker querying the Abood Labs distribution channel.

---

### 4. 🍲 مطبخي (Matbakhi) — Offline Pantry, Recipes & Cook-Along Companion (v1.0.0)
- **[Download Matbakhi.apk (v1.0.0)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.0.0-kitchen/Matbakhi.apk)**
- **Package ID:** `com.tuckai.kitchen`
- **Build:** `versionCode 1`
- **SHA-256 Checksum:** `17ff95c832355edfe58865bfa701f19adc843a94bc3bb61c5c88ecb3334605e8`
- **Highlights:**
  - 100% offline, Arabic-only, RTL-first — no accounts, no network permission at all.
  - 20+ built-in Iraqi recipes with real ingredients and steps, plus a full recipe builder.
  - "ماذا أطبخ؟" ingredient-match engine and a guided cook mode that updates the pantry
    and shopping list automatically.
  - Signed update manifests and APK signer pinning like every other app in the suite.

---

*All applications are signed with the shared ecosystem key for trusted in-app cross-installation.
Manifest checksums are computed from the APKs by `generate-release.ps1` — never edited by hand.*