#!/usr/bin/env bash
set -euo pipefail

echo "Stopping and removing SignSelo Linux Agent..."
systemctl stop signselo.service 2>/dev/null || true
systemctl disable signselo.service 2>/dev/null || true
rm -f /etc/systemd/system/signselo.service
systemctl daemon-reload

rm -f /usr/local/bin/signselo-agent
rm -rf /etc/signselo /var/log/signselo

echo "SignSelo Linux Agent removed successfully."
