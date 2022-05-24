#!/bin/bash

webVer=$(get_release Jai-JAP/hyper-arm-builds)
armhf_url="https://github.com/Jai-JAP/hyper-arm-builds/releases/download/v${webVer}/hyper_${webVer}_armv7l.deb"
arm64_url="https://github.com/Jai-JAP/hyper-arm-builds/releases/download/v${webVer}/hyper_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
