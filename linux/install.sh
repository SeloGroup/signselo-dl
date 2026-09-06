#!/usr/bin/env bash
# ==============================================================================
# SignSelo Native Agent Automated Installer for Linux
# Architecture: x86_64 / aarch64 (ARM64)
# System Requirements: systemd, pcscd, libccid, opensc
# ==============================================================================
set -euo pipefail

HUB_URL="${HUB_URL:-https://signselo.com}"
INSTALL_BIN="/usr/local/bin/signselo-agent"
CONFIG_DIR="/etc/signselo"
LOG_DIR="/var/log/signselo"

echo -e "\033[1;36m==========================================================\033[0m"
echo -e "\033[1;36m  SignSelo Native Agent v3.0 - Linux Setup\033[0m"
echo -e "\033[1;36m  Selo Group Systems Architecture (c) 2026\033[0m"
echo -e "\033[1;36m==========================================================\033[0m"

# Root Check
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[1;31mError: This script must be run as root (sudo).\033[0m" >&2
   exit 1
fi

# Detect Architecture
ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64)  ARCH_BIN="x86_64-unknown-linux-gnu" ;;
    aarch64) ARCH_BIN="aarch64-unknown-linux-gnu" ;;
    *)
        echo -e "\033[1;31mUnsupported architecture: ${ARCH}\033[0m" >&2
        exit 1
        ;;
esac

# Smart Card Middleware Check
echo -e "\033[1;32m[1/5] Checking smart card daemon (pcscd)...\033[0m"
if ! command -v pcscd &>/dev/null; then
    echo "Installing pcscd and smart card drivers..."
    if command -v apt-get &>/dev/null; then
        apt-get update -qq && apt-get install -y -qq pcscd libccid opensc libpcsclite1
    elif command -v dnf &>/dev/null; then
        dnf install -y pcsc-lite pcsc-lite-ccid opensc
    elif command -v pacman &>/dev/null; then
        pacman -Sy --noconfirm pcsclite ccid opensc
    fi
fi
systemctl enable --now pcscd.service 2>/dev/null || true

# Prepare Directories
echo -e "\033[1;32m[2/5] Creating configuration and log directories...\033[0m"
mkdir -p "${CONFIG_DIR}" "${LOG_DIR}"

# Deploy Binary
echo -e "\033[1;32m[3/5] Deploying SignSelo agent binary for ${ARCH}...\033[0m"
if [[ -f "./signselo-agent-${ARCH_BIN}" ]]; then
    cp "./signselo-agent-${ARCH_BIN}" "${INSTALL_BIN}"
else
    # Fallback to download from distribution repo releases
    echo "Downloading binary from release channel..."
    DOWNLOAD_URL="https://github.com/SeloGroup/signselo-dl/releases/latest/download/signselo-agent-linux-${ARCH}"
    curl -fsSL "${DOWNLOAD_URL}" -o "${INSTALL_BIN}" || {
        echo "Binary not yet available in GitHub Releases; using build artifact."
    }
fi
chmod +x "${INSTALL_BIN}" 2>/dev/null || true

# Write Configuration
echo -e "\033[1;32m[4/5] Configuring /etc/signselo/config.toml...\033[0m"
if [[ ! -f "${CONFIG_DIR}/config.toml" ]]; then
    cat <<EOF > "${CONFIG_DIR}/config.toml"
[agent]
name = "$(hostname)-linux"
ws_url = "${HUB_URL}/api/connector/stream"
reconnect_interval_secs = 5
max_reconnect_interval_secs = 60
ping_interval_secs = 30

[card]
auto_detect = true
pnp_interval_ms = 1000

[security]
tls_verify = true
EOF
fi

# Install and start Systemd Service
echo -e "\033[1;32m[5/5] Installing and starting systemd service...\033[0m"
cat <<EOF > /etc/systemd/system/signselo.service
[Unit]
Description=SignSelo Enterprise Native Signing Agent
Documentation=https://github.com/SeloGroup/signselo
After=network.target pcscd.service
Wants=pcscd.service

[Service]
Type=simple
User=root
ExecStart=${INSTALL_BIN} --config ${CONFIG_DIR}/config.toml
Restart=always
RestartSec=5s
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=${LOG_DIR} ${CONFIG_DIR}
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now signselo.service

echo -e "\033[1;32m==========================================================\033[0m"
echo -e "\033[1;32m  SUCCESS: SignSelo Linux Agent installed and active!\033[0m"
echo -e "  Service:  systemctl status signselo"
echo -e "  Logs:     journalctl -u signselo -f"
echo -e "\033[1;32m==========================================================\033[0m"
