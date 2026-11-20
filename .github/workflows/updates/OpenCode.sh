#!/bin/bash

webVer=$(get_release anomalyco/opencode)
arm64_url="https://github.com/anomalyco/opencode/releases/download/v${webVer}/opencode-linux-arm64.tar.gz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
