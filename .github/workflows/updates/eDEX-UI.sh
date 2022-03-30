#!/bin/bash

webVer=$(get_release GitSquared/edex-ui)
armhf_url="https://github.com/GitSquared/edex-ui/releases/download/v${webVer}/eDEX-UI-Linux-armv7l.AppImage"
arm64_url="https://github.com/GitSquared/edex-ui/releases/download/v${webVer}/eDEX-UI-Linux-arm64.AppImage"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh