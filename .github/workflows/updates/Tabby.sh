#!/bin/bash

webVer=$(get_release Jai-JAP/tabby-arm-builds)
arm64_url="https://github.com/Jai-JAP/tabby-arm-builds/releases/download/v${version}/tabby-${version}-linux.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
