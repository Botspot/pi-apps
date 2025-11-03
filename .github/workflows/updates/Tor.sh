#!/bin/bash

webVer="$(get_release ooovlad/tor-mullvad-aarch64)"
arm64_url="https://github.com/ooovlad/tor-mullvad-aarch64/releases/download/${webVer}/tor-browser-linux-aarch64-${webVer}.tar.xz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
