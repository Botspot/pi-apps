#!/bin/bash

webVer=$(get_release Jai-JAP/hyper-arm-builds)
armhf_url="https://github.com/Jai-JAP/hyper-arm-builds/releases/download/v${version}/hyper_${version}_armv7l.deb"
arm64_url="https://github.com/Jai-JAP/hyper-arm-builds/releases/download/v${version}/hyper_${version}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh