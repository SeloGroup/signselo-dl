# SignSelo Companion for Android (NFC & eID)

Native Android companion application that transforms any NFC-enabled smartphone into a high-security Smart Card signing terminal for Georgian Citizen eID cards.

## 📱 Features

* **Direct NFC APDU Transceiver**: Direct communication with Georgian eID ISO-7816 smart card chip.
* **PIN2 Authentication**: Protected PIN verification without storing credentials.
* **Hardware SHA-256 Digest**: On-card RSA-2048 / RSA-4096 signing.
* **Instant QR & DeepLink Handshake**: Scans QR code or triggers via `signselo://mobile-sign?session=...&hub=...` from mobile browsers.

---

## 📥 Installation

### Option 1: Direct APK Sideload
1. Download [**SignSelo-Companion.apk**](./SignSelo-Companion.apk).
2. Allow installation from unknown sources on your Android device.
3. Open the APK and complete installation.

### Option 2: Build from Source
From the `SignSelo` core repository:
```bash
cd mobile/android
./gradlew assembleRelease
```
The resulting APK will be located at:
`mobile/android/app/build/outputs/apk/release/app-release-unsigned.apk`

---

## 💳 Georgian eID NFC Scanning Guide

1. Ensure **NFC is enabled** in Android Settings.
2. Tap **"SignSelo აპლიკაციით გახსნა"** on the mobile signing landing page or scan the QR code.
3. Place your Georgian ID card against the back of the phone (usually near the top camera module).
4. Enter your 4-digit **PIN2 (ხელმოწერის კოდი)** when prompted.
5. Keep the card steady until the green checkmark appears.
