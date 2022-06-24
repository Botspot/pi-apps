#!/bin/bash

webVer=$(get_release minbrowser/min)
armhf_url="https://github.com/minbrowser/min/releases/download/v${webVer}/min-${webVer}-armv7l.deb"
arm64_url="https://github.com/minbrowser/min/releases/download/v${webVer}/min-${webVer}-arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
