#!/usr/bin/env bash
#
# simulated_traffic.sh — simulate network traffic (web, IM, file downloads)
# Tested on Ubuntu 24.04
# Created by https://github.com/PinePad79

set -euo pipefail

# -----------------------------------------------------------------------------
# Helper: install a package if missing
install_pkg() {
  local pkg=$1
  if ! dpkg -s "$pkg" &>/dev/null; then
    echo "→ Installing $pkg..."
    sudo apt-get update -qq
    sudo apt-get install -y "$pkg"
  fi
}

# Ensure dependencies
for p in wget curl coreutils netcat-openbsd openssl; do
  install_pkg "$p"
done

# -----------------------------------------------------------------------------
simulate_web_traffic() {
  echo
  echo "=== Web browsing traffic ==="

  SITES=( example.com nytimes.com techcrunch.com forbes.com pornsite.com onlyfans.com )

  echo
  echo "--- HTTP (port 80)"
  for host in "${SITES[@]}"; do
    url="http://$host"
    echo "- Testing $url"
    if timeout 8 curl -m 8 -s -S -I "$url" &>/dev/null; then
      echo "  ✔ OK"
    else
      echo "  ✖ FAILED"
    fi
  done

  echo
  echo "--- HTTPS (port 443)"
  for host in "${SITES[@]}"; do
    url="https://$host"
    echo "- Testing $url"
    if timeout 8 curl -m 8 -s -S -I "$url" &>/dev/null; then
      echo "  ✔ OK"
    else
      echo "  ✖ FAILED"
    fi
  done
}

# -----------------------------------------------------------------------------
simulate_im_traffic() {
  echo
  echo "=== Instant Messaging (XMPP) traffic ==="

  # Using public XMPP server jabber.at for both ports
  XMPP_HOST="jabber.at"

  echo
  echo "- Unencrypted (port 5222)"
  if timeout 8 nc -vz "$XMPP_HOST" 5222 &>/dev/null; then
    echo "  ✔ OK"
  else
    echo "  ✖ FAILED"
  fi

  echo
  echo "- Encrypted (port 5223)"
  if timeout 8 openssl s_client -connect "$XMPP_HOST":5223 </dev/null &>/dev/null; then
    echo "  ✔ OK"
  else
    echo "  ✖ FAILED"
  fi
}

# -----------------------------------------------------------------------------
simulate_file_downloads() {
  echo
  echo "=== File download traffic ==="

  echo
  echo "- Downloading 5 MB test file"
  if timeout 60 wget --timeout=8 --tries=1 "https://speed.hetzner.de/5MB.bin" -O /tmp/5MB.bin &>/dev/null; then
    echo "  ✔ Downloaded to /tmp/5MB.bin"
  else
    echo "  ✖ FAILED"
  fi

  EICAR_URLS=(
    "https://secure.eicar.org/eicar.com"
    "https://secure.eicar.org/eicar.com.txt"
    "https://secure.eicar.org/eicar_com.zip"
    "https://secure.eicar.org/eicar_com2.zip"
  )
  for url in "${EICAR_URLS[@]}"; do
    fn="/tmp/$(basename "$url")"
    echo
    echo "- Downloading EICAR from $url"
    if timeout 60 wget --timeout=8 --tries=1 "$url" -O "$fn" &>/dev/null; then
      echo "  ✔ Saved to $fn"
    else
      echo "  ✖ FAILED"
    fi
  done
}

# -----------------------------------------------------------------------------
main() {
  echo ">>> Starting simulated traffic $(date)"
  simulate_web_traffic
  simulate_im_traffic
  simulate_file_downloads
  echo
  echo ">>> Done $(date)"
}

main "$@"