# SignSelo Companion for iOS (CoreNFC & eID)

Native iOS companion app utilizing Apple's `CoreNFC` framework for Georgian Citizen eID signing. Compatible with iPhone 7 and newer on iOS 15.0+.

## 📱 Architecture & Capabilities

* **CoreNFC ISO-7816 Tag Reader**: Directly sends APDU commands to Georgian ID cards.
* **Biometric Guard**: Face ID / Touch ID protects session entry before prompting for smart card PIN2.
* **Universal Links & DeepLink Protocol**:
  * Universal Link: `https://signselo.com/m/s/:sessionId`
  * URI Scheme: `signselo://mobile-sign?session=:sessionId&hub=:hubUrl`

---

## 🚀 Deployment & Distribution

### 1. TestFlight Beta Testing
Enterprise and public beta builds can be distributed via Apple TestFlight:
* Internal Selo Group testers: Automatic deployment via Xcode Cloud / Fastlane.
* Public link: Issued per release tag.

### 2. Enterprise In-House Distribution (IPA)
For municipal, governmental, or banking deployments:
1. Export signed IPA using Apple Enterprise Developer Program certificate.
2. Distribute via Mobile Device Management (MDM) or secure enterprise OTA manifest (`itms-services://?action=download-manifest&url=...`).

### 3. Mobile Safari Web Fallback (No App Required)
Users without the native companion app installed can open the mobile session directly in Safari:
* Displays document details and cryptographic hash.
* Polls real-time signing state.
* Once signed via desktop or companion app, displays the completed certificate chain and instant download link.
