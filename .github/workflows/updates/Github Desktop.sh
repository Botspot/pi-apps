#!/bin/bash

webVer=$(get_release_raw shiftkey/desktop | sed 's/release-//g' )
armhf_url="https://github.com/shiftkey/desktop/releases/download/release-${webVer}/GitHubDesktop-linux-armhf-${webVer}.deb"
arm64_url="https://github.com/shiftkey/desktop/releases/download/release-${webVer}/GitHubDesktop-linux-arm64-${webVer}.deb"
source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
