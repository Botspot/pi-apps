#!/bin/bash

webVer=$(get_release Jai-JAP/hyper-arm-builds)
armhf_url="https://github.com/Jai-JAP/hyper-arm-builds/releases/download/v${version}/hyper_${version}_armv7l.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh

unset webVer
unset armhf_url
webVer=$(get_release vercel/hyper)
arm64_url="https://github.com/vercel/hyper/releases/download/v${version}/hyper_${version}_arm64.deb"
source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
