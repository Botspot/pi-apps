#!/bin/bash

# check every new version of Geekbench 7
# this script starts a 7.0.0 and increments the version numbers (rev first and then minor) to find the latest available version
url_for() { echo "https://cdn.geekbench.com/Geekbench-$1-LinuxARMPreview.tar.gz"; }
exists()  { wget -q --spider "$(url_for "$1")"; }

major=7 minor=0 rev=0
version=""

if exists "$major.$minor.$rev"; then
  while true; do
    if exists "$major.$minor.$((rev + 1))"; then
      rev=$((rev + 1))
    elif exists "$major.$((minor + 1)).0"; then
      minor=$((minor + 1)); rev=0
    else
      break
    fi
  done
  version="$major.$minor.$rev"
fi

arm64_url="https://cdn.geekbench.com/Geekbench-${version}-LinuxARMPreview.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
