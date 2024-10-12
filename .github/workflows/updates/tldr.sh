#!/bin/bash

webVer=$(get_release tealdeer-rs/tealdeer)
armhf_url="https://github.com/tealdeer-rs/tealdeer/releases/download/v${webVer}/tealdeer-linux-arm-musleabihf"
arm64_url="https://github.com/tealdeer-rs/tealdeer/releases/download/v${webVer}/tealdeer-linux-aarch64-musl"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
