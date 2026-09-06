# SignSelo Native Agent for macOS

High-performance native agent supporting **Apple Silicon (M1/M2/M3/M4)** and **Intel (x86_64)** Macs. Uses macOS CryptoTokenKit and PCSC framework.

## 🚀 Quick Automated Install

Open Terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/macos/install.sh | sudo bash
```

This installs:
* Binary: `/usr/local/bin/signselo-agent`
* Configuration: `/etc/signselo/config.toml`
* Daemon: `/Library/LaunchDaemons/com.signselo.agent.plist`

---

## 🛠️ Management Commands

```bash
# Check if daemon is running
sudo launchctl list | grep signselo

# View daemon logs
tail -f /var/log/signselo.log

# Stop daemon
sudo launchctl unload -w /Library/LaunchDaemons/com.signselo.agent.plist

# Start daemon
sudo launchctl load -w /Library/LaunchDaemons/com.signselo.agent.plist
```
