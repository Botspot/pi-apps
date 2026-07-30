#!/bin/bash

webVer="$(get_release vscodium/vscodium)"
# armhf builds no longer published by upstream after v1.121.x
arm64_url="https://github.com/VSCodium/vscodium/releases/download/${webVer}/codium_${webVer}_arm64.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
