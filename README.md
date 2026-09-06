# SignSelo 3 Client Distribution Hub (signselo-dl)

[![Selo Group](https://img.shields.io/badge/Selo_Group-Enterprise_Security-0ea5e9.svg)](https://selo.ge)
[![Edition](https://img.shields.io/badge/Edition-SignSelo_3_(Gen_3)-8b5cf6.svg)](https://signselo.com)
[![Platforms](https://img.shields.io/badge/Platforms-Windows%20|%20Linux%20|%20macOS%20|%20Android%20|%20iOS-22c55e.svg)](#supported-platforms)
[![Rust](https://img.shields.io/badge/Rust-Native_Daemon_v3.0-orange.svg)](https://github.com/SeloGroup/signselo)
[![eID & SmartCard](https://img.shields.io/badge/eID-Georgian_Citizen_Card-blue.svg)](https://signselo.com)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](#license)

Official distribution repository for **SignSelo 3 Enterprise (Gen 3) Client Applications, Daemons, and Mobile Companions**. 

**SignSelo 3 (Gen 3)** represents the third-generation cryptographic signature ecosystem: a **Zero-Extension, Zero-Java** architecture featuring native asynchronous Rust daemons, outbound-only secure WSS tunnels, and direct hardware smart card (eID / USB token / NFC) integration across all major desktop and mobile operating systems.

---

## ⚡ Quick Install Matrix

| Operating System | Architecture | Installation Command | Details |
| :--- | :--- | :--- | :--- |
| **Windows 10/11, Server** | x86_64 | `irm https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/windows/install.ps1 \| iex` | [Windows Guide](./windows/README.md) |
| **Linux (Ubuntu, Debian, RHEL)** | x86_64, ARM64 | `curl -fsSL https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/linux/install.sh \| sudo bash` | [Linux Guide](./linux/README.md) |
| **macOS (Apple Silicon & Intel)** | ARM64, x86_64 | `curl -fsSL https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/macos/install.sh \| sudo bash` | [macOS Guide](./macos/README.md) |
| **Android (9.0+)** | ARM64, ARMv7 | Download APK directly or sideload | [Android Guide](./android/README.md) |
| **iOS (15.0+)** | iPhone 7+ | TestFlight / Enterprise IPA distribution | [iOS Guide](./ios/README.md) |

---

## 📦 Direct Downloads Catalog

### 🪟 Windows (x64)
* **[SignSelo-Agent.exe](./windows/SignSelo-Agent.exe)** (3.5 MB) — Standalone native executable with built-in service manager.
* **[SignSelo-Agent-v3.0.0-win64.zip](./windows/SignSelo-Agent-v3.0.0-win64.zip)** (2.8 MB) — Portable deployment archive with installation scripts and default config.
* **[install.ps1](./windows/install.ps1)** — Automated non-interactive PowerShell installer.

### 🐧 Linux
* **[install.sh](./linux/install.sh)** — Automated installer for Debian, Ubuntu, Fedora, RHEL, and Arch.
* **[signselo.service](./linux/signselo.service)** — Hardened systemd service unit.

### 🍏 macOS
* **[install.sh](./macos/install.sh)** — Automated LaunchDaemon installer for macOS.
* **[com.signselo.agent.plist](./macos/com.signselo.agent.plist)** — macOS LaunchAgent daemon definition.

### 📱 Android & iOS (Mobile Companions)
* **Android**: [SignSelo Companion APK Guide](./android/README.md) (NFC ISO-7816 Georgian ID card reader).
* **iOS**: [SignSelo Companion iOS Guide](./ios/README.md) (Apple CoreNFC & Universal Link reader).

---

## 🛡️ Cryptographic Integrity (SHA-256)

All distribution files are cryptographically hashed. You can verify integrity using:

```bash
# Windows PowerShell
Get-FileHash -Algorithm SHA256 ./windows/SignSelo-Agent.exe

# Linux / macOS
sha256sum -c CHECKSUMS.sha256
```

Detailed hashes are stored in [**CHECKSUMS.sha256**](./CHECKSUMS.sha256).

---

## 🌐 Enterprise Coexistence & Zero Conflicts

SignSelo was architected from the ground up for strict coexistence with municipal and legacy environments:
1. **No Port 9795 Collision**: SignSelo uses an outbound WebSocket gateway (`/api/connector/stream`), completely avoiding localhost port collisions with legacy NexU (`127.0.0.1:9795`).
2. **No Chrome Extension Required**: Communicates directly through modern secure WebSockets.
3. **High Security**: TLS 1.3 encryption, Smart Card Plug-and-Play (PnP) telemetry, and memory safety through Rust.

---

## 🏢 Organization & Support

Developed and maintained by **Selo Group**.  
* **Core Private Repository**: [github.com/SeloGroup/signselo](https://github.com/SeloGroup/signselo)  
* **Official International Portal**: [signselo.com](https://signselo.com)  
* **Documentation & Releases**: [github.com/SeloGroup/signselo-dl](https://github.com/SeloGroup/signselo-dl)
