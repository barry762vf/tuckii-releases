# ⚡ Abood Labs — Official Android Releases

Official public distribution repository for the **Abood Labs** ecosystem suite of Android applications.

> Every `*.apk` here is signed with the unified ecosystem key, and `version.json` / `apps.json`
> are published with detached ECDSA P-256 signatures (`*.sig`). Installed apps verify the
> signature, the SHA-256 checksum **and** the APK's signing certificate before installing.
> Regenerate this file with `.\generate-release.ps1` — never edit hashes by hand.

---

### 1. 🔖 Tuckii — Offline-First Media & Bookmark Manager (v1.5.0)
- **[Download Tuckii.apk (v1.5.0)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.5.0/Tuckii.apk)**
- **Package ID:** `com.tuckai.app`
- **Build:** `versionCode 24`
- **SHA-256 Checksum:** `177ce8f894c046a6470a721ce37bcf4e7cbda9f9eaa5c6c1c14b2f434169aec7`
- **Highlights:**
  - Update prompts restored for users on older builds (version-code driven detection).
  - Every update verified: manifest signature, SHA-256 and APK signing certificate.
  - Signed update manifests — a compromised repository cannot redirect installs.
  - 100% in-app video downloader, instant search, batch undo.

---

### 2. 🚀 Abood Labs — Creative Studio Hub & Ecosystem Portal (v1.1.0)
- **[Download AboodLabs.apk (v1.1.0)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.1.0-hub/AboodLabs.apk)**
- **Package ID:** `com.tuckai.hub`
- **Build:** `versionCode 5`
- **SHA-256 Checksum:** `d7f44a2d515bacab2a069daf1beee882de64aa225dc42280c90a35dfaeb420da`
- **Highlights:**
  - Signature-verified suite manifest; installs pinned to the official certificate.
  - Suite launcher with automatic startup update checks for all ecosystem apps.
  - Native launch and 1-tap in-app install for Tuckii and Aman.

---

### 3. 🚨 Aman | أمان — Emergency Guide & Rapid Safety Response (v1.0.6)
- **[Download Aman.apk (v1.0.6)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.0.6-aman/Aman.apk)**
- **Package ID:** `com.iraq.emergency.guide`
- **Build:** `versionCode 7`
- **SHA-256 Checksum:** `b9425932565a08679b2e8eb9ac2b0949061efa6df8d120cc8205496094721ae6`
- **Highlights:**
  - Update manifest verified natively before the JavaScript layer is trusted.
  - 911 Instant SOS and complete unified Iraqi emergency directory.
  - 100% offline first aid protocols and anti-extortion dispatch.
  - In-app OTA update checker querying the Abood Labs distribution channel.

---

### 4. 🍲 مطبخي (Matbakhi) — Offline Pantry, Recipes & Cook-Along Companion (v1.1.0)
- **[Download Matbakhi.apk (v1.1.0)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.1.0-kitchen/Matbakhi.apk)**
- **Package ID:** `com.tuckai.kitchen`
- **Build:** `versionCode 2`
- **SHA-256 Checksum:** `cd12741f1e6f4c7e298c45817cddb49d38a0b46860939d5610b7e6840b3e4214`
- **Highlights:**
  - 100% offline, Arabic-only, RTL-first — no accounts, no network permission at all.
  - 20+ built-in Iraqi recipes with real ingredients and steps, plus a full recipe builder.
  - "ماذا أطبخ؟" ingredient-match engine and a guided cook mode that updates the pantry
    and shopping list automatically.
  - Signed update manifests and APK signer pinning like every other app in the suite.

---

*All applications are signed with the shared ecosystem key for trusted in-app cross-installation.
Manifest checksums are computed from the APKs by `generate-release.ps1` — never edited by hand.*