#!/bin/bash

webVer=$(get_release TurboWarp/desktop)
armhf_url="https://github.com/TurboWarp/desktop/releases/download/v${webVer}/TurboWarp-linux-armv7l-${webVer}.deb"
arm64_url="https://github.com/TurboWarp/desktop/releases/download/v${webVer}/TurboWarp-linux-arm64-${webVer}.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
