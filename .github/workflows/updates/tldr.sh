#!/bin/bash

webVer=$(get_release dbrgn/tealdeer)
armhf_url="https://github.com/dbrgn/tealdeer/releases/download/v${webVer}/tealdeer-linux-arm-musleabihf"
arm64_url="https://github.com/dbrgn/tealdeer/releases/download/v${webVer}/tealdeer-linux-armv7-musleabihf"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
