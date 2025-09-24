#!/bin/bash

# Extract versions from the specific structure:
# Lines look like:
# <img ...> <a href="tbb-nightly.2025.09.24/">tbb-nightly.2025.09.24/</a> 2025-09-24 14:28    -
# Then sort by YYYYMMDD numerically to be portable (no reliance on sort -V).
webVer="$(
  wget -qO- "https://nightlies.tbb.torproject.org/nightly-builds/tor-browser-builds" 2>/dev/null \
  | sed -nE 's@.*href="tbb-nightly\.([0-9]{4}\.[0-9]{2}\.[0-9]{2})/".*@\1@p' \
  | awk -F. 'NF==3 { printf "%s %s%s%s\n", $0, $1, $2, $3 }' \
  | LC_ALL=C sort -k2,2n \
  | tail -n 1 \
  | cut -d' ' -f1
)"
arm64_url="https://nightlies.tbb.torproject.org/nightly-builds/tor-browser-builds/tbb-nightly.$webVer/nightly-linux-aarch64/tor-browser-linux-aarch64-tbb-nightly.$webVer.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
