# SignSelo Native Agent for Linux (x86_64 & ARM64)

Native headless daemon designed for Linux workstations and servers. Supports Ubuntu, Debian, Red Hat Enterprise Linux, Rocky Linux, Fedora, and Arch Linux.

## 🚀 Quick Automated Install

Run the following command as `sudo`:

```bash
curl -fsSL https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/linux/install.sh | sudo bash
```

This script:
1. Installs the required PC/SC smart card daemon (`pcscd`, `libccid`, `opensc`).
2. Deploys the native binary to `/usr/local/bin/signselo-agent`.
3. Creates the configuration `/etc/signselo/config.toml`.
4. Registers and starts a hardened **systemd service** (`signselo.service`).

---

## 🛠️ Service Management

```bash
# Check service status
sudo systemctl status signselo

# View live telemetry and signing logs
sudo journalctl -u signselo -f

# Restart daemon
sudo systemctl restart signselo
```

---

## 🔐 Smart Card Verification

Ensure your smart card reader is detected by Linux:

```bash
# List connected readers
opensc-tool -l

# Test eID communication
pkcs11-tool --module /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so -L
```
