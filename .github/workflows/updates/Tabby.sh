#!/bin/bash

webVer=$(get_release Jai-JAP/tabby-arm-builds)
armhf_url="https://github.com/Jai-JAP/tabby-arm-builds/releases/download/v${webVer}/tabby-${webVer}-linux-armhf.deb"
arm64_url="https://github.com/Jai-JAP/tabby-arm-builds/releases/download/v${webVer}/tabby-${webVer}-linux-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
