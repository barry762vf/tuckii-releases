# ⚡ Abood Labs — Official Android Releases

Official public distribution repository for the **Abood Labs** ecosystem suite of Android applications.

> Every `*.apk` here is signed with the unified ecosystem key, and `version.json` / `apps.json`
> are published with detached ECDSA P-256 signatures (`*.sig`). Installed apps verify the
> signature, the SHA-256 checksum **and** the APK's signing certificate before installing.
> Regenerate this file with `.\generate-release.ps1` — never edit hashes by hand.

---

### 1. 🔖 Tuckii — Offline-First Media & Bookmark Manager (v1.4.8)
- **[Download Tuckii.apk (v1.4.8)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.4.8/Tuckii.apk)**
- **Package ID:** `com.tuckai.app`
- **Build:** `versionCode 22`
- **SHA-256 Checksum:** `1d2706832799392c0a44e4732442922305f8facd619b4102956c3b032ba55678`
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

### 3. 🚨 Aman | أمان — Emergency Guide & Rapid Safety Response (v1.0.3)
- **[Download Aman.apk (v1.0.3)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.0.3-aman/Aman.apk)**
- **Package ID:** `com.iraq.emergency.guide`
- **Build:** `versionCode 4`
- **SHA-256 Checksum:** `e4b5716df0f1a7855ee1aa4b0ead99c07eed34a220544d54157f2777bfd33b55`
- **Highlights:**
  - Update manifest verified natively before the JavaScript layer is trusted.
  - 911 Instant SOS and complete unified Iraqi emergency directory.
  - 100% offline first aid protocols and anti-extortion dispatch.
  - In-app OTA update checker querying the Abood Labs distribution channel.

---

*All applications are signed with the shared ecosystem key for trusted in-app cross-installation.
Manifest checksums are computed from the APKs by `generate-release.ps1` — never edited by hand.*