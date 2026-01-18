#!/bin/bash

webVer=$(get_release aristocratos/btop)
armhf_url="https://github.com/aristocratos/btop/releases/download/v${webVer}/btop-armv7-unknown-linux-musleabi.tbz"
arm64_url="https://github.com/aristocratos/btop/releases/download/v${webVer}/btop-aarch64-unknown-linux-musl.tbz"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh