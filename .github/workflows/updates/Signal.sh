#!/bin/bash

webVer=$(get_release dennisameling/Signal-Desktop)
arm64_url="https://github.com/dennisameling/Signal-Desktop/releases/download/v${webVer}/signal-desktop-unofficial_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
