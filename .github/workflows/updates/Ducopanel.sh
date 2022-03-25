#!/bin/bash

webVer=$(get_release ponsato/ducopanel)
arm64_url="https://github.com/ponsato/ducopanel/releases/download/${webVer}/ducopanel_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh