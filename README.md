# ⚡ Abood Labs — Official Android Releases

Official public distribution repository for the **Abood Labs** ecosystem suite of Android applications.

> Every `*.apk` here is signed with the unified ecosystem key, and `version.json` / `apps.json`
> are published with detached ECDSA P-256 signatures (`*.sig`). Installed apps verify the
> signature, the SHA-256 checksum **and** the APK's signing certificate before installing.
> Regenerate this file with `.\generate-release.ps1` — never edit hashes by hand.

---

### 1. 🔖 Tuckii — Offline-First Media & Bookmark Manager (v1.6.1)
- **[Download Tuckii.apk (v1.6.1)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.6.1/Tuckii.apk)**
- **Package ID:** `com.tuckai.app`
- **Build:** `versionCode 26`
- **SHA-256 Checksum:** `45f5eaf8cd925e5a104ebd356b68e67e8be42a721783fa2da474946da4ad1d56`
- **Highlights:**
  - Update prompts restored for users on older builds (version-code driven detection).
  - Every update verified: manifest signature, SHA-256 and APK signing certificate.
  - Signed update manifests — a compromised repository cannot redirect installs.
  - 100% in-app video downloader, instant search, batch undo.
  - Bookmarks stay on device. Saving links contacts their pages and metadata providers; optional video downloads send the selected URL to external resolver services unaffiliated with Tuckii.
  - Scoped Matbakhi collaboration collection with stable record identity; private notes are not shared.

---

### 2. 🚀 Abood Labs — Creative Studio Hub & Ecosystem Portal (v1.4.2)
- **[Download AboodLabs.apk (v1.4.2)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.4.2-hub/AboodLabs.apk)**
- **Package ID:** `com.tuckai.hub`
- **Build:** `versionCode 10`
- **SHA-256 Checksum:** `18f72663d502681124eb605a6179e01383a58e5981ef885d7d189ddbed90f2cd`
- **Highlights:**
  - Signature-verified suite manifest; installs pinned to the official certificate.
  - Suite launcher with automatic startup update checks for all ecosystem apps.
  - Native launch and 1-tap in-app install for available suite apps.
  - Horizontal, tap-to-enlarge screenshots captured from the Android emulator.
  - Full-width Arabic app names stay on one line without clipping.

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

### 4. 🍲 مطبخي (Matbakhi) — Offline Pantry, Recipes & Cook-Along Companion (v1.2.1)
- **[Download Matbakhi.apk (v1.2.1)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.2.1-kitchen/Matbakhi.apk)**
- **Package ID:** `com.tuckai.kitchen`
- **Build:** `versionCode 4`
- **SHA-256 Checksum:** `9ad59f6779a1f425ae844043e7a9cde9d92f33b85d5e8784ae3c374813628fa4`
- **Highlights:**
  - Local-first, Arabic-only, RTL-first, with no accounts or app backend. Internet access is used for signed update checks and APK downloads; pantry and recipe data stays on the device.
  - 50 built-in Iraqi recipes with real ingredients and steps, plus a full recipe builder.
  - "ماذا أطبخ؟" ingredient-match engine and a guided cook mode that updates the pantry
    and shopping list automatically.
  - Tuckii imports become persistent, editable drafts with source provenance and duplicate protection.
    User approval remains controlled by Tuckii.
  - Signed update manifests and APK signer pinning like every other app in the suite.

---

### 5. منهاج — Quran Companion (public beta)
- **[Download Minhaj.apk (v1.2.0)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.2.0-minhaj-beta/Minhaj.apk)**
- **Package ID:** `com.tuckai.minhaj`
- **Build:** `versionCode 3`
- **SHA-256 Checksum:** `23422d99ab313cfc3c99367cc6d17c782d91c10f63fd439c3da6e326fa7662e4`
- Arabic-first reading, listening and progress tracking for in-app or physical Mushaf use.
- Curated Quran passages and Quranic supplications; no hadith or tafsir section.
- **Beta:** content checks are automated and are not scholarly approval; qualified review is still pending.

---

### 6. 🩺 medicalWay — Study Companion for Medical Students (v1.0.0)
- **[Download MedicalWay.apk (v1.0.0)](https://github.com/barry762vf/tuckii-releases/releases/download/v1.0.0-medicalway/MedicalWay.apk)**
- **Package ID:** `com.tuckai.medicalway`
- **Build:** `versionCode 1`
- **SHA-256 Checksum:** `f32e095ce6d87d1deaac644814a2c1defd04e39dbe53676511561d6c99603327`
- **Highlights:**
  - Stylus-first PDF lecture notes: pressure pen, highlighter, palm rejection, draw-and-hold lines, bookmarks, search, annotated export.
  - Record lectures while writing; tap any note to hear that moment, or replay notes in sync with the audio.
  - Optional AI tutor (Google Gemini with the user's own key) maps what the lecturer explained to each slide, and builds flashcards and MCQs.
  - FSRS flashcards with image occlusion, tutor and timed exam modes, focus timer, backup and restore.
  - Data stays on the device; internet is used only for the optional AI tutor and signed update checks.
---

*All applications are signed with the shared ecosystem key for trusted in-app cross-installation.
Manifest checksums are computed from the APKs by `generate-release.ps1` — never edited by hand.*