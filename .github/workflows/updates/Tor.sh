#!/bin/bash

# Extract versions from the specific structure:
# Lines look like:
# <img ...> <a href="tbb-nightly.2025.09.24/">tbb-nightly.2025.09.24/</a> 2025-09-24 14:28    -
# Then sort by YYYYMMDD numerically to be portable (no reliance on sort -V).
# Then retrieve current pi-apps version and compare those to be 5 days off each other.
get_latest_nightly_version() {
  wget -qO- "https://nightlies.tbb.torproject.org/nightly-builds/tor-browser-builds" 2>/dev/null \
    | sed -nE 's@.*href="tbb-nightly\.([0-9]{4}\.[0-9]{2}\.[0-9]{2})/".*@\1@p' \
    | sort \
    | tail -n 1
}

get_installed_version() {
  # Expect a line like: version=2025.09.24
  if [[ -f install-64 ]]; then
    # Stop at first match; trim whitespace
    sed -nE 's/^version=([0-9]{4}\.[0-9]{2}\.[0-9]{2})\s*$/\1/p' install-64 | head -n1
  fi
}

days_between() {
  # Args: date1 date2 (YYYY.MM.DD)
  local d1="$1" d2="$2"
  local e1 e2
  e1=$(date -d "${d1//./-}" +%s) || return 1
  e2=$(date -d "${d2//./-}" +%s) || return 1
  local diff=$(( e1 - e2 ))
  (( diff < 0 )) && diff=$(( -diff ))
  echo $(( diff / 86400 ))
}

choose_version() {
  local remote installed
  remote=$(get_latest_nightly_version || true)
  installed=$(get_installed_version || true)

  # If no remote, nothing to do
  if [[ -z $remote ]]; then
    echo ""
    return
  fi

  # If no installed version, just use remote
  if [[ -z $installed ]]; then
    echo "$remote"
    return
  fi

  # Validate formats
  if [[ ! $remote =~ ^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$ ]] || \
     [[ ! $installed =~ ^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$ ]]; then
    echo "$remote"   # fall back to let update script call an error
    return
  fi

  local delta
  delta=$(days_between "$remote" "$installed") || {
    echo "$installed"
    return
  }

  if (( delta >= 5 )); then
    echo "$remote"
  else
    echo "$installed"
  fi
}

version_arm64="$(choose_version)"
arm64_url="https://nightlies.tbb.torproject.org/nightly-builds/tor-browser-builds/tbb-nightly.${version_arm64}/nightly-linux-aarch64/tor-browser-linux-aarch64-tbb-nightly.${version_arm64}.tar.xz"



# Older unofficial build for armhf update script:
version_armhf="$(wget -qO- https://sourceforge.net/projects/tor-browser-ports/files | grep -F 'Download Latest Version' --after 1 | tail -n -1 | tr '<>\-_' '\n' | sed -n 8p | sed 's/\.tar\.xz.*//g')"
armhf_url="https://sourceforge.net/projects/tor-browser-ports/files/${version_armhf}/tor-browser-linux-armhf-${version_armhf}.tar.xz/download"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
