#!/usr/bin/env bash
set -euo pipefail

echo "Stopping and uninstalling SignSelo macOS Agent..."
PLIST_DST="/Library/LaunchDaemons/com.signselo.agent.plist"

launchctl unload -w "${PLIST_DST}" 2>/dev/null || true
rm -f "${PLIST_DST}"
rm -f /usr/local/bin/signselo-agent
rm -rf /etc/signselo

echo "SignSelo Agent uninstalled."
