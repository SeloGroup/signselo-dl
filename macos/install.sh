#!/usr/bin/env bash
# ==============================================================================
# SignSelo Native Agent Automated Installer for macOS
# Supports: Apple Silicon (M1/M2/M3/M4) & Intel (x86_64)
# ==============================================================================
set -euo pipefail

HUB_URL="${HUB_URL:-https://signselo.com}"
INSTALL_BIN="/usr/local/bin/signselo-agent"
PLIST_DST="/Library/LaunchDaemons/ge.selo.signselo.plist"

echo -e "\033[1;36m==========================================================\033[0m"
echo -e "\033[1;36m  SignSelo Native Agent v3.0 - macOS Setup\033[0m"
echo -e "\033[1;36m  Selo Group Systems Architecture (c) 2026\033[0m"
echo -e "\033[1;36m==========================================================\033[0m"

if [[ $EUID -ne 0 ]]; then
   echo -e "\033[1;31mError: Please run as root: sudo bash install.sh\033[0m" >&2
   exit 1
fi

ARCH="$(uname -m)"
echo "Detected macOS Architecture: ${ARCH}"

# Ensure /usr/local/bin exists
mkdir -p /usr/local/bin /etc/signselo /var/log

# Download binary if not local
if [[ -f "./signselo-agent-darwin-${ARCH}" ]]; then
    cp "./signselo-agent-darwin-${ARCH}" "${INSTALL_BIN}"
else
    echo "Fetching latest binary release..."
    DOWNLOAD_URL="https://github.com/SeloGroup/signselo-dl/releases/latest/download/signselo-agent-darwin-${ARCH}"
    curl -fsSL "${DOWNLOAD_URL}" -o "${INSTALL_BIN}" || true
fi
chmod +x "${INSTALL_BIN}" 2>/dev/null || true

# Config
if [[ ! -f "/etc/signselo/config.toml" ]]; then
    cat <<EOF > /etc/signselo/config.toml
[agent]
name = "$(scutil --get ComputerName)-mac"
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

# Deploy LaunchDaemon
cat <<EOF > "${PLIST_DST}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>ge.selo.signselo</string>
    <key>ProgramArguments</key>
    <array>
        <string>${INSTALL_BIN}</string>
        <string>--config</string>
        <string>/etc/signselo/config.toml</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/var/log/signselo.log</string>
    <key>StandardErrorPath</key>
    <string>/var/log/signselo-err.log</string>
</dict>
</plist>
EOF

chmod 644 "${PLIST_DST}"
launchctl load -w "${PLIST_DST}" 2>/dev/null || true

echo -e "\033[1;32m==========================================================\033[0m"
echo -e "\033[1;32m  SUCCESS: SignSelo macOS Agent active via LaunchDaemon!\033[0m"
echo -e "  Logs: tail -f /var/log/signselo.log"
echo -e "\033[1;32m==========================================================\033[0m"
