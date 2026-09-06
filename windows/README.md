# SignSelo Native Agent for Windows (x64)

Standalone, High-Performance Native Digital Signature Daemon written in Rust. Designed for enterprise eID Smart Card signing without requiring Java or Chrome extensions.

## 🚀 Quick Automated Install (Recommended)

Open **PowerShell as Administrator** and execute:

```powershell
irm https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/windows/install.ps1 | iex
```

This single command:
1. Downloads `SignSelo-Agent.exe` to `C:\Program Files\SignSelo`.
2. Creates the default hardened configuration `config.toml`.
3. Registers and starts the agent as a native background **Windows Service** (`SignSeloAgent`) with Automatic Startup.

---

## 📦 Direct Downloads

| Artifact | Type | Architecture | Size | Checksum (SHA-256) |
| :--- | :--- | :--- | :--- | :--- |
| [**SignSelo-Agent.exe**](./SignSelo-Agent.exe) | Standalone Binary | x86_64 | ~3.5 MB | `3a947fd10c7bf85b46f70e03d6e31dc86add1c00a2894ce459a997ecb387e7f6` |
| [**SignSelo-Agent-v3.0.0-win64.zip**](./SignSelo-Agent-v3.0.0-win64.zip) | Portable Archive | x86_64 | ~2.8 MB | `e5367244585f82a7d68d3062a17eab55633b68636f737722ba3c40049f53eec0` |

---

## 🛠️ Windows Service Management CLI

SignSelo Agent features built-in Windows Service management commands. Run from an elevated terminal:

```cmd
# Check service status
SignSelo-Agent.exe service status

# Start service
SignSelo-Agent.exe service start

# Stop service
SignSelo-Agent.exe service stop

# Reinstall service
SignSelo-Agent.exe service install

# Uninstall service
SignSelo-Agent.exe service uninstall
```

---

## 🔒 Enterprise Compatibility & Coexistence

* **Zero Conflict with NexU**: Runs on Outbound WSS and does NOT bind to `127.0.0.1:9795`, allowing municipal and legacy NexU Java installations to coexist flawlessly.
* **Smart Card PnP**: Detects card insertion/removal in real time without polling delay.
* **PKCS#11 Native Engine**: Directly speaks to Georgian eID smart card drivers and middleware.
