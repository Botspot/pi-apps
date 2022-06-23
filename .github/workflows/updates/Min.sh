#!/bin/bash

webVer=$(get_release minbrowser/min)
armhf_url="https://github.com/minbrowser/min/releases/download/v${webVer}/min_${webVer}_armhf.deb"
arm64_url="https://github.com/minbrowser/min/releases/download/v${webVer}/min_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh