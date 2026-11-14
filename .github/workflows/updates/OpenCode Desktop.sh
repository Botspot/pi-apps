#!/bin/bash

version=$(get_release anomalyco/opencode)
arm64_url="https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
