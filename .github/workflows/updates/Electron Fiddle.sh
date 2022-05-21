#!/bin/bash

webVer=$(get_release electron/fiddle)
armhf_url="https://github.com/electron/fiddle/releases/download/v${webVer}/electron-fiddle_${webVer}_armhf.deb"
arm64_url="https://github.com/electron/fiddle/releases/download/v${webVer}/electron-fiddle_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
