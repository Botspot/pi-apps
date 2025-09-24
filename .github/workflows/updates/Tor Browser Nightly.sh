#!/bin/bash
# Thanks GitHub Copilot for parsing/sorting code.

URL="https://nightlies.tbb.torproject.org/nightly-builds/tor-browser-builds"

# Fetch directory listing
html="$(wget -qO- "$URL" 2>/dev/null || true)"
if [ -z "${html}" ]; then
  error "Error: failed to fetch URL: $URL"
fi

# Extract versions from the specific structure:
# Lines look like:
# <img ...> <a href="tbb-nightly.2025.09.24/">tbb-nightly.2025.09.24/</a> 2025-09-24 14:28    -

versions="$(
  echo "$html" \
  | sed -nE 's@.*href="tbb-nightly\.([0-9]{4}\.[0-9]{2}\.[0-9]{2})/".*@\1@p'
)"

if [ -z "$versions" ]; then
  error "Error: no nightly versions found at $URL"
fi

# Sort by YYYYMMDD numerically to be portable (no reliance on sort -V).
latest="$(
  printf '%s\n' "$versions" \
  | awk -F. 'NF==3 { printf "%s %s%s%s\n", $0, $1, $2, $3 }' \
  | LC_ALL=C sort -k2,2n \
  | tail -n 1 \
  | cut -d' ' -f1
)"

if [ -z "$latest" ]; then
  echo "Error: failed to determine latest nightly from parsed versions."
fi

webVer="$latest"
arm64_url="https://nightlies.tbb.torproject.org/nightly-builds/tor-browser-builds/tbb-nightly.$webVer/nightly-linux-aarch64/tor-browser-linux-aarch64-tbb-nightly.$webVer.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh