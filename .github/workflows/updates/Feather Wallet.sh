#!/bin/bash

webVer=$(get_release feather-wallet/feather)
armhf_url="https://github.com/feather-wallet/feather/releases/download/${webVer}/feather-${webVer}-arm.AppImage"
arm64_url="https://github.com/feather-wallet/feather/releases/download/${webVer}/feather-${webVer}-arm64.AppImage"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
